#!/usr/bin/env python3
"""Create paper drafts and validate the repository's paper layout (Python 3.9+)."""

import argparse
from datetime import date
import json
import os
from pathlib import Path
import re
import shutil
from string import Template
import sys


ROOT = Path(__file__).resolve().parent.parent
MONTHS = (
    "January", "February", "March", "April", "May", "June", "July", "August",
    "September", "October", "November", "December",
)
SLUG_PATTERN = re.compile(r"[a-z0-9]+(?:-[a-z0-9]+)*")
FIELDS = {"title", "summary", "date", "tags", "ignore"}
REQUIRED = FIELDS - {"ignore"}


def valid_slug(value):
    if not isinstance(value, str) or not SLUG_PATTERN.fullmatch(value):
        raise ValueError("slug must contain lowercase letters/digits separated by single hyphens")
    return value


def unique_object(pairs):
    result = {}
    for key, value in pairs:
        if key in result:
            raise ValueError(f"duplicate JSON key: {key}")
        result[key] = value
    return result


def invalid_constant(value):
    raise ValueError(f"invalid JSON constant: {value}")


def read_json(path):
    return json.loads(
        path.read_text(encoding="utf-8"),
        object_pairs_hook=unique_object,
        parse_constant=invalid_constant,
    )


def metadata_date(value):
    match = re.fullmatch(r"([A-Za-z]+) ([0-9]{1,2}), ([0-9]{4})", value)
    if not match:
        raise ValueError("date must use an English month, e.g. October 18, 2026 or Oct 18, 2026")
    month_name, day, year = match.groups()
    for month, name in enumerate(MONTHS, start=1):
        if month_name in (name, name[:3]):
            date(int(year), month, int(day))
            return
    raise ValueError("date contains an unknown English month")


def metadata_errors(metadata):
    if not isinstance(metadata, dict):
        return ["metadata must be a JSON object"]
    errors = []
    missing = REQUIRED - metadata.keys()
    unknown = metadata.keys() - FIELDS
    if missing:
        errors.append(f"missing metadata fields: {', '.join(sorted(missing))}")
    if unknown:
        errors.append(f"unknown metadata fields: {', '.join(sorted(unknown))}")
    title = metadata.get("title")
    if not isinstance(title, str) or not title.strip() or len(title.splitlines()) != 1:
        errors.append("title must be a nonempty, single-line string")
    summary = metadata.get("summary")
    if not isinstance(summary, str) or (not summary.strip() and metadata.get("ignore") is not True):
        errors.append("summary must be a string, nonempty unless ignore is true")
    if "ignore" in metadata and not isinstance(metadata["ignore"], bool):
        errors.append("ignore must be a boolean")
    tags = metadata.get("tags")
    if not isinstance(tags, list) or not tags or any(
        not isinstance(tag, str) or not tag.strip() for tag in tags
    ):
        errors.append("tags must be a nonempty array of nonempty strings")
    elif len(set(tags)) != len(tags):
        errors.append("tags must not contain duplicates")
    value = metadata.get("date")
    if not isinstance(value, str):
        errors.append("date must be a string")
    else:
        try:
            metadata_date(value)
        except ValueError as error:
            errors.append(str(error))
    return errors


def chart_errors(manuscript, directory):
    """Check includes only in chart fences; ordinary code examples are not assets."""
    errors = []
    fence = None
    chart = False
    for line in manuscript.splitlines():
        marker = re.match(r"^ {0,3}(`{3,}|~{3,})(.*)$", line)
        if fence is None:
            if marker:
                fence = marker.group(1)
                chart = marker.group(2).strip() == "chart"
            continue
        if marker and marker.group(1)[0] == fence[0] and len(marker.group(1)) >= len(fence) and not marker.group(2).strip():
            fence = None
            chart = False
            continue
        if not chart or not line.strip().startswith("@include"):
            continue
        parts = line.strip().split()
        if len(parts) != 2 or parts[0] != "@include":
            errors.append("chart include must use '@include relative/path.json'")
            continue
        relative = Path(parts[1])
        target = (directory / relative).resolve()
        if relative.is_absolute() or not target.is_relative_to(directory.resolve()) or target.suffix != ".json":
            errors.append(f"chart include must be a JSON file inside the paper: {parts[1]}")
            continue
        try:
            if not isinstance(read_json(target), dict):
                errors.append(f"chart include must contain a JSON object: {parts[1]}")
        except (OSError, ValueError) as error:
            errors.append(f"chart include {parts[1]}: {error}")
    return errors


def paper_errors(directory):
    errors = []
    try:
        valid_slug(directory.name)
    except ValueError as error:
        errors.append(str(error))
    try:
        errors.extend(metadata_errors(read_json(directory / "metadata.json")))
    except (OSError, ValueError) as error:
        errors.append(f"metadata.json: {error}")
    manuscript_path = directory / f"{directory.name}.md"
    try:
        manuscript = manuscript_path.read_text(encoding="utf-8")
        if not re.match(r"\A# [^\n\r\S]*\S", manuscript):
            errors.append(f"{manuscript_path.name} must start with a nonempty H1 heading")
        errors.extend(chart_errors(manuscript, directory))
    except (OSError, ValueError) as error:
        errors.append(f"{manuscript_path.name}: {error}")
    preview = directory / "preview.png"
    if not preview.is_file() or preview.stat().st_size == 0:
        errors.append("preview.png must be a nonempty file")
    return errors


def create_paper(args):
    slug = valid_slug(args.slug)
    if not args.title or not args.title.strip():
        raise ValueError("provide --title or TITLE")
    if not args.tags or not args.tags.strip():
        raise ValueError("provide --tags or TAGS as a comma-separated list")
    if args.date and not re.fullmatch(r"[0-9]{4}-[0-9]{2}-[0-9]{2}", args.date):
        raise ValueError("--date / DATE must use YYYY-MM-DD")
    published = date.fromisoformat(args.date) if args.date else date.today()
    templates = ROOT / "templates" / "paper"
    metadata = read_json(templates / "metadata.json")
    metadata.update(
        title=args.title.strip(), summary=args.summary.strip(),
        date=f"{MONTHS[published.month - 1]} {published.day}, {published.year:04d}",
        tags=[tag.strip() for tag in args.tags.split(",")], ignore=True,
    )
    errors = metadata_errors(metadata)
    if errors:
        raise ValueError("; ".join(errors))
    manuscript = Template((templates / "paper.md").read_text(encoding="utf-8")).substitute(
        slug=slug, title=metadata["title"], summary=metadata["summary"],
    )
    preview = ROOT / "assets" / "images" / "preview.png"
    if not preview.is_file() or preview.stat().st_size == 0:
        raise ValueError("starter preview is missing or empty: assets/images/preview.png")
    directory = ROOT / "papers" / slug
    # mkdir is exclusive: a repeated invocation must never replace an existing draft.
    directory.mkdir()
    try:
        (directory / "metadata.json").write_text(json.dumps(metadata, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")
        (directory / f"{slug}.md").write_text(manuscript, encoding="utf-8")
        shutil.copyfile(preview, directory / "preview.png")
        errors = paper_errors(directory)
        if errors:
            raise ValueError("; ".join(errors))
    except Exception:
        shutil.rmtree(directory)
        raise
    print(f"Created papers/{slug}/ as an ignored draft.")
    print("Replace the starter preview, complete the manuscript, and review metadata before publication.")


def verify_papers(args):
    papers = ROOT / "papers"
    if args.slug:
        directories = [papers / valid_slug(args.slug)]
    else:
        directories = sorted(path for path in papers.iterdir() if path.is_dir())
    if not directories:
        raise ValueError("no paper directories found")
    failures = 0
    for directory in directories:
        for error in paper_errors(directory):
            print(f"papers/{directory.name}: {error}", file=sys.stderr)
            failures += 1
    if failures:
        print(f"Verification failed with {failures} error(s).", file=sys.stderr)
        return 1
    print(f"Verified {len(directories)} paper(s), including ignored drafts. Editorial review is still required.")
    return 0


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    subparsers = parser.add_subparsers(dest="command", required=True)
    new = subparsers.add_parser("new", help="generate an ignored draft from templates/paper")
    new.add_argument("--slug", default=os.environ.get("SLUG"), help="lowercase kebab-case name (or SLUG)")
    new.add_argument("--title", default=os.environ.get("TITLE"), help="paper title (or TITLE)")
    new.add_argument("--summary", default=os.environ.get("SUMMARY", ""), help="summary, empty for drafts (or SUMMARY)")
    new.add_argument("--tags", default=os.environ.get("TAGS"), help="comma-separated tags (or TAGS)")
    new.add_argument("--date", default=os.environ.get("DATE"), help="YYYY-MM-DD; defaults to today (or DATE)")
    verify = subparsers.add_parser("verify", help="validate paper structure, metadata, and chart includes")
    verify.add_argument("--slug", default=os.environ.get("SLUG"), help="one paper; defaults to all (or SLUG)")
    args = parser.parse_args()
    try:
        if args.command == "new":
            create_paper(args)
            return 0
        return verify_papers(args)
    except (OSError, ValueError) as error:
        print(f"error: {error}", file=sys.stderr)
        return 1


if __name__ == "__main__":
    sys.exit(main())

#!/usr/bin/env python3
"""Record one text file at two Git commits for editorial review (Python 3.9+)."""

import argparse
from pathlib import Path, PurePosixPath
import re
import subprocess


def git(repo, *arguments):
    result = subprocess.run(
        ["git", "-C", str(repo), *arguments], capture_output=True,
    )
    if result.returncode:
        raise ValueError(result.stderr.decode("utf-8", errors="replace").strip())
    return result.stdout


def text_blob(repo, commit, path):
    data = git(repo, "cat-file", "blob", f"{commit}:{path}")
    if b"\0" in data:
        raise ValueError(f"{path} at {commit[:12]} contains NUL bytes; use a UTF-8 text file")
    try:
        return data.decode("utf-8")
    except UnicodeDecodeError as error:
        raise ValueError(f"{path} at {commit[:12]} is not UTF-8 text") from error


def fenced(text, language="text"):
    # Manuscripts may contain fenced code; do not let it escape the snapshot.
    longest = max((len(run) for run in re.findall(r"`+", text)), default=0)
    fence = "`" * max(3, longest + 1)
    ending = "" if text.endswith("\n") else "\n"
    return f"{fence}{language}\n{text}{ending}{fence}\n"


def snapshot(label, text):
    final_newline = "yes" if text.endswith("\n") else "no"
    return f"## {label}\n\nFinal newline in source: {final_newline}.\n\n{fenced(text)}"


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("path", help="file path relative to the Git repository root; use / separators")
    parser.add_argument("--before", required=True, help="earlier Git commit, branch, or tag")
    parser.add_argument("--after", required=True, help="later Git commit, branch, or tag")
    parser.add_argument("--intent", required=True, help="the intended improvement, not a verdict")
    parser.add_argument("--output", type=Path, required=True, help="new Markdown record; never overwritten")
    parser.add_argument("--repo", type=Path, default=Path.cwd(), help="Git working tree (default: current directory)")
    args = parser.parse_args()

    try:
        path = PurePosixPath(args.path)
        if path.is_absolute() or ".." in path.parts or not path.parts or any(
            c in args.path for c in "\r\n\0"
        ):
            raise ValueError("path must be a relative file path inside the repository")
        if not args.intent.strip():
            raise ValueError("intent must describe the intended improvement")
        root = Path(git(args.repo, "rev-parse", "--show-toplevel").decode().strip())
        commits = [
            git(root, "rev-parse", "--verify", "--end-of-options", f"{ref}^{{commit}}")
            .decode().strip()
            for ref in (args.before, args.after)
        ]
        before, after = [text_blob(root, commit, path.as_posix()) for commit in commits]
        if before == after:
            raise ValueError("no content changes between these versions of the file")
        diff = git(
            root, "diff", "--no-ext-diff", "--no-textconv", "--no-color", "--no-renames",
            "--text", "--unified=3", *commits, "--", f":(literal){path.as_posix()}",
        ).decode("utf-8")
        versions = f"File: {path.as_posix()}\nBefore commit: {commits[0]}\nAfter commit:  {commits[1]}\n"
        report = (
            "# Revision review\n\n"
            "Snapshots and diff are captured from Git. Review judgments below are unfinished.\n"
            "Uncommitted changes are not included.\n\n"
            f"## Versions\n\n{fenced(versions)}\n"
            f"## Intended improvement\n\n{args.intent.strip()}\n\n"
            "## Review\n\n"
            "- Reviewer and date: _not recorded_\n"
            "- Observed benefits: _not reviewed_\n"
            "- Unintended effects found: _not reviewed_\n"
            "- Evidence checked / remaining uncertainty: _not reviewed_\n"
            "- Decision (keep, revise, or revert) and reason: _not decided_\n"
            "- Follow-up / related review records: _not recorded_\n\n"
            f"{snapshot('Before', before)}\n{snapshot('After', after)}\n"
            f"## Diff\n\n{fenced(diff, 'diff')}"
        )
        output = args.output.absolute()
        git_dir = Path(git(root, "rev-parse", "--absolute-git-dir").decode().strip()).resolve()
        resolved = output.resolve()
        if resolved == (root / path).resolve() or resolved.is_relative_to(git_dir):
            raise ValueError("output must not be the source file or inside Git's internal directory")
        output.parent.mkdir(parents=True, exist_ok=True)
        with output.open("x", encoding="utf-8", newline="") as handle:
            handle.write(report)
    except (OSError, ValueError) as error:
        parser.exit(1, f"error: {error}\n")
    print(f"Created {output}; complete the review before treating it as an assessment.")


if __name__ == "__main__":
    main()

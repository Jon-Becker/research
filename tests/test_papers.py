"""Exercise the paper-authoring commands against disposable repositories."""

import datetime
import json
import os
from pathlib import Path
import shutil
import subprocess
import sys
import tempfile
import unittest


REPO = Path(__file__).resolve().parents[1]


class PaperCommandsTest(unittest.TestCase):
    def setUp(self):
        temporary = tempfile.TemporaryDirectory()
        self.addCleanup(temporary.cleanup)
        self.root = Path(temporary.name)
        (self.root / "papers").mkdir()
        (self.root / "scripts").mkdir()
        shutil.copy2(REPO / "scripts/papers.py", self.root / "scripts/papers.py")
        shutil.copytree(REPO / "templates", self.root / "templates")
        (self.root / "assets/images").mkdir(parents=True)
        shutil.copy2(REPO / "assets/images/preview.png", self.root / "assets/images/preview.png")
        shutil.copy2(REPO / "Makefile", self.root / "Makefile")
        self.paper = self.root / "papers/example-paper"

    def command(self, *arguments, ok=True, cwd=None):
        result = subprocess.run(
            [sys.executable, str(self.root / "scripts/papers.py"), *arguments],
            cwd=cwd or self.root, capture_output=True, text=True,
        )
        self.check_result(result, ok)
        return result

    def check_result(self, result, ok):
        output = result.stdout + result.stderr
        if ok:
            self.assertEqual(result.returncode, 0, output)
        else:
            self.assertNotEqual(result.returncode, 0, output)
            self.assertTrue(output.strip(), "Failures should explain the problem")

    def new(self, *arguments, slug="example-paper", **kwargs):
        return self.command(
            "new", "--slug", slug, "--title", "Example Paper", "--tags", "evm,research",
            *arguments, **kwargs,
        )

    def metadata(self):
        return json.loads((self.paper / "metadata.json").read_text(encoding="utf-8"))

    def write_metadata(self, value):
        (self.paper / "metadata.json").write_text(json.dumps(value), encoding="utf-8")

    def manuscript(self, text):
        (self.paper / "example-paper.md").write_text(text, encoding="utf-8")

    def test_generate_draft_and_verify_from_another_directory(self):
        elsewhere = self.root / "another-directory"
        elsewhere.mkdir()
        self.new("--date", "2026-10-18", cwd=elsewhere)
        self.assertEqual(self.metadata(), {
            "title": "Example Paper", "summary": "", "date": "October 18, 2026",
            "tags": ["evm", "research"], "ignore": True,
        })
        self.assertTrue((self.paper / "example-paper.md").read_text().startswith("# Example Paper"))
        self.assertEqual(
            (self.paper / "preview.png").read_bytes(),
            (self.root / "assets/images/preview.png").read_bytes(),
        )
        self.command("verify", cwd=elsewhere)
        self.command("verify", "--slug", "example-paper", cwd=elsewhere)

    def test_default_date_is_today_and_summary_is_preserved(self):
        before = datetime.date.today()
        self.new("--summary", "A concise description.")
        after = datetime.date.today()
        months = (
            "January February March April May June July August September October November December"
        ).split()
        expected = {f"{months[day.month - 1]} {day.day}, {day.year}" for day in (before, after)}
        self.assertIn(self.metadata()["date"], expected)
        self.assertEqual(self.metadata()["summary"], "A concise description.")

    def test_generation_rejects_invalid_inputs_without_creating_a_paper(self):
        for slug in ("../escaped", "Upper-Case", "has_space", "two--dashes", "/absolute"):
            with self.subTest(slug=slug):
                self.new(slug=slug, ok=False)
        for arguments in (
            ("--title", " "), ("--tags", ""), ("--tags", "evm,evm"),
            ("--date", "2026-02-30"),
        ):
            with self.subTest(arguments=arguments):
                self.new(*arguments, ok=False)
        for missing in ("--slug", "--title", "--tags"):
            options = {"--slug": "example-paper", "--title": "Example", "--tags": "evm"}
            del options[missing]
            self.command("new", *(item for pair in options.items() for item in pair), ok=False)
        self.assertFalse(self.paper.exists())
        self.assertFalse((self.root / "escaped").exists())

    def test_existing_paper_is_never_overwritten(self):
        self.new()
        self.manuscript("# Existing draft\n\nKeep this work.\n")
        before = {path.name: path.read_bytes() for path in self.paper.iterdir() if path.is_file()}
        self.new("--title", "Replacement", ok=False)
        after = {path.name: path.read_bytes() for path in self.paper.iterdir() if path.is_file()}
        self.assertEqual(after, before)

    def test_invalid_template_rolls_back_generated_paper(self):
        template = self.root / "templates/paper/paper.md"
        original = template.read_text(encoding="utf-8")
        template.write_text(original + "\n```chart\n@include fig/missing.json\n```\n", encoding="utf-8")
        self.new(ok=False)
        self.assertFalse(self.paper.exists())
        self.assertEqual(list((self.root / "papers").iterdir()), [])
        template.write_text(original, encoding="utf-8")
        self.new()
        self.command("verify")

    def test_every_required_metadata_field_is_checked(self):
        self.new()
        original = self.metadata()
        for field in ("title", "summary", "date", "tags"):
            with self.subTest(field=field):
                altered = dict(original)
                del altered[field]
                self.write_metadata(altered)
                self.command("verify", ok=False)

    def test_metadata_rejects_invalid_types_and_values(self):
        self.new()
        original = self.metadata()
        cases = (
            ("title", " "), ("title", 42), ("summary", None),
            ("date", "February 30, 2026"), ("date", "2026-10-18"), ("date", 2026),
            ("tags", []), ("tags", "evm"), ("tags", [" "]), ("tags", [7]),
            ("tags", ["evm", "evm"]), ("ignore", "true"), ("ignore", 1),
            ("unknown", "value"),
        )
        for field, value in cases:
            with self.subTest(field=field, value=value):
                self.write_metadata(dict(original, **{field: value}))
                self.command("verify", ok=False)

    def test_malformed_and_duplicate_json_are_rejected(self):
        self.new()
        valid = json.dumps(self.metadata())
        for text in ("{", "[]", valid[:-1] + ', "title": "Duplicate"}'):
            with self.subTest(text=text):
                (self.paper / "metadata.json").write_text(text, encoding="utf-8")
                self.command("verify", ok=False)

    def test_published_papers_require_summary_and_ignore_is_optional(self):
        self.new()
        metadata = self.metadata()
        metadata["ignore"] = False
        self.write_metadata(metadata)
        self.command("verify", ok=False)
        del metadata["ignore"]
        self.write_metadata(metadata)
        self.command("verify", ok=False)
        metadata["summary"] = "Research findings and their limitations."
        for date in ("February 29, 2024", "Feb 29, 2024"):
            metadata["date"] = date
            self.write_metadata(metadata)
            self.command("verify")

    def test_ignored_papers_are_still_verified_and_slug_can_select_one(self):
        self.new()
        self.new(slug="second-paper")
        (self.root / "papers/second-paper/metadata.json").write_text("{}")
        self.command("verify", ok=False)
        self.command("verify", "--slug", "example-paper")
        self.command("verify", "--slug", "missing-paper", ok=False)
        self.command("verify", "--slug", "../example-paper", ok=False)

    def test_manuscript_and_preview_must_exist_and_be_nonempty(self):
        self.new()
        for name in ("example-paper.md", "preview.png", "metadata.json"):
            path = self.paper / name
            original = path.read_bytes()
            with self.subTest(name=name, state="missing"):
                path.unlink()
                self.command("verify", ok=False)
            with self.subTest(name=name, state="empty"):
                path.write_bytes(b"")
                self.command("verify", ok=False)
            path.write_bytes(original)
        self.manuscript("This manuscript has no heading.\n")
        self.command("verify", ok=False)
        self.manuscript("# A deliberately different display title\n\nContent.\n")
        self.command("verify")

    def test_chart_includes_resolve_local_json_objects(self):
        self.new()
        (self.paper / "fig").mkdir()
        chart = self.paper / "fig/chart.json"
        self.manuscript("# Example\n\n```chart\n@include fig/chart.json\n```\n")
        for content in (None, "{", "[]"):
            with self.subTest(content=content):
                if content is not None:
                    chart.write_text(content)
                self.command("verify", ok=False)
        chart.write_text('{"type": "bar"}')
        self.command("verify")

    def test_chart_includes_cannot_escape_paper_or_use_non_json_files(self):
        self.new()
        outside = self.root / "outside.json"
        outside.write_text("{}")
        (self.paper / "chart.txt").write_text("{}")
        (self.paper / "linked.json").symlink_to(outside)
        for target in ("../../outside.json", str(outside), "linked.json", "chart.txt"):
            with self.subTest(target=target):
                self.manuscript(f"# Example\n\n```chart\n@include {target}\n```\n")
                self.command("verify", ok=False)

    def test_unrelated_include_text_and_remote_links_are_not_local_charts(self):
        self.new()
        self.manuscript(
            "# Example\n\n@include missing.json\n\n```text\n@include missing.json\n```\n"
            "\n[External figure](https://example.invalid/chart.json)\n"
        )
        self.command("verify")

    @unittest.skipUnless(shutil.which("make"), "make is not installed")
    def test_make_command_line_assignments_preserve_dollars_and_make_syntax(self):
        title = "$625M $(shell touch injected-make) ${HOME} $$ and $@"
        summary = "Literal $(TITLE) and $(shell touch injected-summary) references."
        result = subprocess.run(
            ["make", "new-paper", "SLUG=example-paper", f"TITLE={title}", "TAGS=evm,research",
             f"SUMMARY={summary}", "DATE=2026-10-18", f"PYTHON={sys.executable}"],
            cwd=self.root, capture_output=True, text=True,
        )
        self.check_result(result, True)
        self.assertEqual(self.metadata()["title"], title)
        self.assertEqual(self.metadata()["summary"], summary)
        self.assertFalse((self.root / "injected-make").exists())
        self.assertFalse((self.root / "injected-summary").exists())
        self.command("verify")

    @unittest.skipUnless(shutil.which("make"), "make is not installed")
    def test_make_preserves_shell_metacharacters_and_verifies_selected_paper(self):
        title = "Alice's \"quoted\" $HOME `touch injected` $(touch injected-too)"
        summary = "Semicolons; ampersands & quotes ' \" and dollars $ stay literal."
        environment = dict(os.environ, SLUG="example-paper", TITLE=title, TAGS="evm,research",
                           SUMMARY=summary, DATE="2026-10-18", PYTHON=sys.executable)
        result = subprocess.run(["make", "new-paper"], cwd=self.root, env=environment,
                                capture_output=True, text=True)
        self.check_result(result, True)
        self.assertEqual(self.metadata()["title"], title)
        self.assertEqual(self.metadata()["summary"], summary)
        self.assertFalse((self.root / "injected").exists())
        self.assertFalse((self.root / "injected-too").exists())
        result = subprocess.run(["make", "verify"], cwd=self.root, env=environment,
                                capture_output=True, text=True)
        self.check_result(result, True)


if __name__ == "__main__":
    unittest.main()

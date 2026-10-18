"""Check revision records against real, disposable Git histories."""

from pathlib import Path
import subprocess
import sys
import tempfile
import unittest


SCRIPT = Path(__file__).resolve().parents[1] / "scripts/review_revision.py"


class RevisionReviewTest(unittest.TestCase):
    def setUp(self):
        temporary = tempfile.TemporaryDirectory()
        self.addCleanup(temporary.cleanup)
        self.directory = Path(temporary.name)
        self.repo = self.directory / "repo"
        self.repo.mkdir()
        self.git("init", "-q")
        self.git("config", "user.name", "Test Author")
        self.git("config", "user.email", "author@example.invalid")
        self.git("config", "commit.gpgsign", "false")
        self.path = "paper.md"
        self.before = self.commit(b"# Finding\n\nIn this workload, latency fell.\n")
        self.after = self.commit(b"# Finding\n\nLatency fell.\n")
        self.output = self.directory / "reviews/review.md"

    def git(self, *arguments):
        return subprocess.run(
            ["git", "-C", str(self.repo), *arguments], check=True,
            capture_output=True,
        ).stdout.decode().strip()

    def commit(self, content):
        (self.repo / self.path).write_bytes(content)
        self.git("add", "--", self.path)
        self.git("commit", "-qm", "Revise example")
        return self.git("rev-parse", "HEAD")

    def command(self, *options, ok=True):
        result = subprocess.run(
            [sys.executable, str(SCRIPT), self.path,
             "--before", self.before, "--after", self.after,
             "--intent", "Shorten without broadening the claim.",
             "--output", str(self.output), *options],
            cwd=self.repo, capture_output=True, text=True,
        )
        if ok:
            self.assertEqual(result.returncode, 0, result.stderr)
        else:
            self.assertNotEqual(result.returncode, 0)
            self.assertIn("error:", result.stderr)
            self.assertNotIn("Traceback", result.stderr)
        return result

    def test_record_resolves_refs_and_ignores_uncommitted_changes(self):
        self.git("tag", "before-edit", self.before)
        dirty = b"An unsaved revision must stay out of the report.\n"
        (self.repo / self.path).write_bytes(dirty)
        status = self.git("status", "--porcelain")
        self.command("--before", "before-edit", "--after", "HEAD")
        report = self.output.read_text()
        self.assertIn(f"Before commit: {self.before}", report)
        self.assertIn(f"After commit:  {self.after}", report)
        self.assertIn("In this workload, latency fell.", report)
        self.assertIn("-In this workload, latency fell.\n+Latency fell.", report)
        self.assertIn("Unintended effects found: _not reviewed_", report)
        self.assertIn("Decision (keep, revise, or revert) and reason: _not decided_", report)
        self.assertNotIn(dirty.decode(), report)
        self.assertEqual((self.repo / self.path).read_bytes(), dirty)
        self.assertEqual(self.git("rev-parse", "HEAD"), self.after)
        self.assertEqual(self.git("status", "--porcelain"), status)

    def test_snapshots_preserve_crlf_nested_fences_and_missing_final_newline(self):
        before = b"# Demo\r\n```python\r\nprint('before')\r\n```\r\n"
        after = b"# Demo\n````text\nafter\n````"
        self.before = self.commit(before)
        self.after = self.commit(after)
        self.command()
        report = self.output.read_bytes()
        self.assertIn(b"````text\n" + before + b"````\n", report)
        self.assertIn(b"`````text\n" + after + b"\n`````\n", report)
        self.assertIn(b"Final newline in source: no.", report)
        self.assertIn(b"\\ No newline at end of file", report)

    def test_existing_record_is_not_overwritten(self):
        self.output.parent.mkdir()
        self.output.write_text("Reviewed by a person; keep this.")
        self.command(ok=False)
        self.assertEqual(self.output.read_text(), "Reviewed by a person; keep this.")

    def test_missing_refs_files_unchanged_content_and_blank_intent_fail_cleanly(self):
        for options in (
            ("--before", "missing-commit"),
            ("--before", "--help"),
            ("--after", self.before),
            ("--intent", " "),
            ("--repo", str(self.directory)),
        ):
            with self.subTest(options=options):
                self.command(*options, ok=False)
                self.assertFalse(self.output.exists())
        for path in ("missing.md", "../paper.md", str(self.repo / "paper.md")):
            with self.subTest(path=path):
                self.path = path
                self.command(ok=False)
                self.assertFalse(self.output.exists())

    def test_binary_and_non_utf8_inputs_fail_cleanly(self):
        for data in (b"binary\0content", b"invalid \xff text"):
            with self.subTest(data=data):
                self.after = self.commit(data)
                self.command(ok=False)
                self.assertFalse(self.output.exists())

    def test_path_metacharacters_are_literal_and_other_files_are_excluded(self):
        self.path = "paper [1] $(touch injected).md"
        self.before = self.commit(b"Before.\n")
        (self.repo / "other.md").write_text("Unrelated change.\n")
        self.git("add", "--", "other.md")
        self.after = self.commit(b"After.\n")
        self.command()
        report = self.output.read_text()
        self.assertIn("-Before.\n+After.", report)
        self.assertNotIn("Unrelated change.", report)
        self.assertFalse((self.repo / "injected").exists())

    def test_output_cannot_recreate_source_or_write_into_git(self):
        source = self.repo / self.path
        source.unlink()
        for output in (source, self.repo / ".git/review.md"):
            with self.subTest(output=output):
                self.command("--output", str(output), ok=False)
                self.assertFalse(output.exists())

    def test_explicit_repository_works_from_elsewhere(self):
        result = subprocess.run(
            [sys.executable, str(SCRIPT), self.path, "--repo", str(self.repo),
             "--before", self.before, "--after", self.after, "--intent", "Clarify.",
             "--output", str(self.output)],
            cwd=self.directory, capture_output=True, text=True,
        )
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertIn(self.before, self.output.read_text())


if __name__ == "__main__":
    unittest.main()

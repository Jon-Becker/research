# Review what a revision changed

An edit can solve its intended problem and introduce another. Removing qualifications may improve the pace while making a claim too broad. Adding careful explanations can make every paragraph follow the same pattern. A Git diff shows the changes; this optional record keeps the intended benefit and the review of its effects beside them.

## Create a record

Requires Git and Python 3.9+, with no additional packages. Commit both versions of the file first. From the repository root:

```sh
python3 scripts/review_revision.py papers/example/example.md \
  --before HEAD~1 --after HEAD \
  --intent "Shorten the explanation while preserving the finding's scope." \
  --output reviews/example-01.md
```

Replace the example path and refs with your file and commits. The file path is relative to the repository root, even when running from a subdirectory; the output path is relative to your current directory. Use `--repo /path/to/repository` to review another working tree.

The script captures full commit IDs, both text versions, their final-newline status, and a diff. It creates the record's parent directory if needed and refuses to overwrite an existing file. It does not change the manuscript, check out a revision, call a model, or send data anywhere. Both commits must be available locally, and the same UTF-8 text-file path must exist in both. Renamed files and uncommitted changes are outside this small tool's scope.

## Complete the review

Write the intended improvement before judging the result. Then read the actual changes, including their surrounding explanation, and fill in:

- **Observed benefits:** what improved, with a passage or other evidence for the judgment.
- **Unintended effects found:** what else changed, including lost qualifications, tone, emphasis, or repetition elsewhere. Record uncertainty rather than treating an unchecked effect as absent.
- **Evidence checked / remaining uncertainty:** which changed claims were checked against which sources, and what is unresolved.
- **Decision and follow-up:** keep, revise, or revert, with a reason. Add the reviewer and date, and link another review if useful.

For scientific or technical claims, preserve the study's scope, the distinction between association and causation, and material uncertainty. Move detail to notes only when the main text remains accurate on its own. Readability and evidence support require separate judgments; this record does not make either one automatically. See the [completed illustrative review](revision-review-example.md).

## Look across revisions

Keep records for consequential edits, rather than every punctuation change. After several rounds, compare an earlier baseline with the current version and read adjoining sections together. This can reveal an accumulating pattern that individual diffs miss, such as each section acquiring the same finding-and-caveat structure. Link the relevant records and explain whether the editing instructions need to change.

The records document what reviewers found, not every effect an edit might have. They complement source verification, technical checks, and fresh-reader feedback. They are not a quality score or a prerequisite for publishing a paper.

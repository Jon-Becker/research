---
name: new-research-paper
description: Create a research paper, security audit, or technical write-up in this repository using its paper template, metadata schema, and verification commands.
---

# New Research Paper

Use this workflow for a new entry under `papers/`. Run commands from the repository root. The tooling requires Python 3.9 or newer and uses only the standard library; the Make targets also require Make.

## Create a draft

Choose a stable lowercase, hyphen-separated slug and a descriptive title. Read one existing paper of the same kind before writing: audits, technical tutorials, release notes, and empirical research need different sections.

```sh
make new-paper SLUG=example-research TITLE='Example Research' TAGS='evm,research'
```

`SLUG`, `TITLE`, and one or more comma-separated `TAGS` are required. Optional `SUMMARY='A concise overview.'` fills the summary; otherwise it starts empty. Optional `DATE=2026-10-18` supplies an ISO calendar date; otherwise the command uses today's date. The stored date uses a full English month, such as `October 18, 2026`.

The equivalent command without Make is:

```sh
python3 scripts/papers.py new \
  --slug example-research \
  --title 'Example Research' \
  --tags 'evm,research' \
  --summary 'A concise overview.' \
  --date 2026-10-18
```

The generator uses `templates/paper/paper.md` and `templates/paper/metadata.json`, copies `assets/images/preview.png` as a starter image, and creates a draft with `ignore: true`. It refuses to overwrite an existing paper. Write the actual research and replace the starter image before publication.

## File layout

```text
papers/<slug>/
  <slug>.md       Required manuscript; filename matches the directory
  metadata.json  Required metadata object
  preview.png    Required nonempty preview image
  summary.txt    Optional standalone summary used by some older papers
  fig/           Optional figures, chart JSON, data, and supporting exports
```

Existing papers also keep numbered images directly beside the manuscript. Prefer descriptive filenames for new supporting assets. `summary.txt` is a separate optional file, not a metadata field or an automatic substitute for `metadata.json`'s summary. Existing standalone summaries may differ from metadata summaries.

## Metadata contract

Use only the fields below. Metadata is a JSON object; do not add duplicate keys, comments, or trailing commas.

| Field | Required | Type and meaning |
| --- | --- | --- |
| `title` | Yes | Nonempty, single-line string: the publication's display title. Match the new manuscript's H1. Existing papers may use a different H1, so verification does not enforce equality. |
| `summary` | Yes | String: a concise, accurate overview of the question and contribution. It may be empty only when `ignore` is `true`. |
| `date` | Yes | String: a real date in `Month D, YYYY` form. Full or abbreviated English month names are accepted for compatibility; generate full names for new papers. |
| `tags` | Yes | Nonempty array of unique, nonempty strings describing the subject. Reuse relevant existing tags; spaces and capital letters are allowed. |
| `ignore` | No | Boolean used as the repository's ignored/draft flag. New drafts set it to `true`; completed papers commonly omit it or set it to `false`. |

For example:

```json
{
  "title": "Example Research",
  "summary": "An investigation of the question, method, and principal finding.",
  "date": "October 18, 2026",
  "tags": ["evm", "research"],
  "ignore": true
}
```

There are no established `author`, `slug`, `doi`, `category`, or `status` metadata fields. Put authorship, external publication links, and relevant provenance in the manuscript when needed. The directory supplies the slug. The downstream publishing implementation is not in this repository, so do not promise that `ignore` provides access control or specific rendering behavior.

## Writing and evidence

- Begin with one H1, a preview image, and an introduction that states the question, scope, and contribution. Choose useful sections for the paper: empirical work normally needs data, methods, results, limitations, and conclusions; audits need reviewed scope, findings, severity, evidence, and remediation.
- Support factual claims with primary sources and link them near the claim. Use a `Resources & Citations` section when a collected bibliography helps. Separate observed results from hypotheses, estimates, and interpretation; identify uncertainty and limitations.
- Make results reproducible: record source datasets, collection windows and timezones, inclusion/exclusion criteria, units, sample sizes, transformations, and the commands or linked code used for analysis. Explain statistical methods, uncertainty, and material assumptions. Retain supporting data or exports when useful and appropriate to share.
- Pin audited or analyzed code to a commit or release and identify the exact files/contracts in scope. For findings, show the affected behavior, evidence, impact, and remediation. Existing audit severity icons live in `assets/images/`.
- Use language-tagged code fences, readable tables, defined notation, and descriptive image alt text. Label illustrative pseudocode and distinguish it from code that was executed. Check runnable examples when practical.
- Replace scaffold instructions and unfinished prose, reconcile all numbers with the supporting analysis, and keep the metadata summary consistent with the final claims. Review source and image attribution before sharing.

## Figures and renderer conventions

Existing papers commonly embed images using URLs such as:

```markdown
![Description](https://raw.githubusercontent.com/Jon-Becker/research/main/papers/example-research/preview.png?fw)
```

The `?fw` suffix is an existing convention. These URLs point at `main`, so assets added on a branch may be unavailable there until merged; inspect the local assets during review. Preview dimensions vary across the corpus, although 1920 × 1080 is common. Supply an actual PNG for a new `preview.png`; legacy verification checks existence and nonemptiness rather than image encoding or dimensions.

For data-heavy work, the prediction-market paper demonstrates local chart includes:

````markdown
```chart
@include fig/results.json
```
````

Keep included files inside the paper directory and use valid JSON objects. Consult an existing chart of the appropriate type: line/bar charts and treemaps use different fields. The repository also contains inline `$...$` and display `$$...$$` math, plus `<context title="Supporting detail">text</context>` annotations. These are existing authoring conventions, but the custom renderer and its complete schema are absent here. Use ordinary Markdown where possible and check the actual publishing preview when available; repository verification does not prove rendered appearance.

## Verify and prepare publication

```sh
make verify SLUG=example-research
make verify
```

Without Make, use `python3 scripts/papers.py verify --slug example-research` or `python3 scripts/papers.py verify`. Verification includes ignored drafts. It checks the directory/filename convention, a nonempty manuscript starting with an H1, a nonempty `preview.png`, metadata fields and types, calendar dates, tags, and local chart include existence and JSON objects. It does not establish scientific correctness, complete content, resolve all links, render the paper, or enforce exact title equality. Use `make test` when changing the generator or verifier.

Before treating a paper as ready:

- Finish the manuscript and nonempty metadata summary; review sources, calculations, reproducibility, limitations, and attribution.
- Replace the starter preview, inspect every figure, and check image/link targets and any custom charts in the intended renderer when available. Report unavailable rendering checks explicitly.
- Review the title, publication date, tags, and summary. Remove `ignore` or set it to `false` when the paper is ready for publication; keep it `true` while incomplete.
- Add the paper to the appropriate Publications section of `README.md` when publishing it, and update `summary.txt` if this paper uses one.
- Run targeted and repository-wide verification, then review the full diff. A passing structural check is necessary but does not replace editorial review. Follow the user's requested review/publication workflow; creating a draft alone does not request publishing it elsewhere.

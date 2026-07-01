# Reviewer Feedback Synthesis Framework

## Structure

For each reviewer (Opus, GPT-5.5, Gemini), capture:

1. **Overall Recommendation** (Accept / Minor / Major Revisions / Reject)
2. **Novelty Assessment** (High / Moderate / Limited)
3. **Rigor Assessment** (High / Moderate / Concerns)
4. **Significance** (High / Moderate / Low)

## Key Questions to Extract

For each reviewer, extract answers to:

- What is the single most novel finding?
- What is the biggest methodological concern?
- What analysis is missing that would strengthen the paper?
- Should this be submitted as-is, revised, or rejected?

## Synthesis Strategy

After all three reviews arrive, create a 2x3 matrix:

```
           Opus        GPT-5.5     Gemini
Novelty:   ?           ?           ?
Rigor:     ?           ?           ?
Signif:    ?           ?           ?

Agreement: ___/3
Consensus recommendation:
```

Then:
1. If 3/3 say "Accept" or "Minor Revisions" → proceed to SSRN
2. If 2/3 say "Major Revisions" → identify the specific gaps and run targeted analyses
3. If any say "Reject" → synthesize the concerns and respond with deep revisions
4. If split verdict (e.g., one "Major", one "Minor", one "Accept") → use the "Major" feedback to prioritize

## Response Actions

For each "Major Revision" request:
- Is it a methodological fix (recompute analysis)? → Delegate to analysis subagent
- Is it a conceptual gap (new section needed)? → Draft new content yourself
- Is it an empirical gap (missing data point)? → delegate to analysis subagent
- Is it a positioning issue (reframe existing content)? → rewrite section

## Success Criteria

Paper is "ready to submit" when:
- All 3 reviewers agree consensus is ≥ "Minor Revisions"
- Opus gives thumbs up on rigor
- GPT-5.5 confirms effect sizes / findings are significant
- Gemini confirms broader implications are sound
- No critical methodological gaps remain

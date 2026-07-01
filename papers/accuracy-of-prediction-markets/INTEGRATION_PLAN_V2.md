# Paper Integration Plan: Analysis 1-3

## Analysis 1: Liquidity Threshold & Price Discovery (DONE)

**Finding:** ~200 trades inflection point; 10-15x MAD improvement; critical for price discovery reliability.

**Section to write:** "Liquidity as a Binding Constraint on Price Discovery" (1.5 pages)
- Insert after current "Category Decomposition" section
- Lead: "We identify a critical liquidity threshold..."
- Figure: 01_liquidity_threshold_analysis.png (3-panel: calibration vs trades, brier vs trades, distribution)
- Key insight: Most prediction markets operate below the minimum viable liquidity for reliable pricing
- Implication: Reviewers' concerns about "generalizability" partly answered—markets need ~200 trades to stabilize

**Addresses reviewer gap:** #3 (robustness checks)

---

## Analysis 2: Maker-Taker Divergence by Category (IN PROGRESS)

**Expected finding:** Taker-side pricing patterns by category; informational asymmetry effects

**Section to write:** "Participant Effects on Market Efficiency" (1-1.5 pages)
- Insert in "Accuracy by Category" section as subsection
- Lead: "Taker-side trades reveal asymmetric information patterns..."
- Figures: expected 2-3 plots (taker effect by category, statistical tests)
- Key mechanism: maker-taker divergence suggests informed vs uninformed trading

**Addresses reviewer gap:** #1 (maker-taker calibration stratification)

---

## Analysis 3: Time-to-Resolution Calibration Decay (IN PROGRESS - RESTARTED)

**Expected finding:** MAD/Brier by market age cohorts (0-10%, 10-50%, 50-90%, 90-100% lifetime); decay patterns

**Section to write:** "Calibration Degradation Across Forecast Horizons" (1-1.5 pages)
- Insert before "Limitations" section
- Lead: "Calibration quality varies systematically with time-to-resolution..."
- Figures: expected 2-3 plots (decay by cohort, correlation with liquidity)
- Key insight: confound with liquidity (older markets may have fewer trades OR genuine information decay)

**Addresses reviewer gap:** #2 (within-market panel component)

---

## Section Write Order

1. Liquidity Threshold (Analysis 1 done, ready to write now)
2. Maker-Taker (Analysis 2 in progress, write once results arrive)
3. Time-to-Resolution (Analysis 3 restarted, write once results arrive)
4. Revise Limitations + add robustness caveats
5. Update Abstract/Intro to reflect new findings

## Word Count Impact

Current: ~6.8k words
+ Liquidity section: ~600 words
+ Maker-Taker section: ~500 words
+ Time-to-Resolution section: ~600 words
+ Revised intro/limitations: ~300 words
= Target: ~8.8k words (reasonable for major revisions submission)

## Integration Timing

- Analysis 1 integrated immediately
- Analysis 2 integrated upon completion (expect ~30 mins from 17:02 start, so ~17:32)
- Analysis 3 integrated upon completion (expect ~30 mins from 17:04 restart, so ~17:34)
- Full revised paper ready by ~17:45
- Reviewer loop can start by ~17:50

# Integration Plan: Novel Analyses → Main Paper

## Current Paper Structure (6.8k words)

1. Introduction & Claims (para)
2. Data & Methodology (section)
3. Calibration (section)
4. Accuracy by Category (section)
5. Brier Decomposition (section)
6. Accuracy Paradox (section)
7. Time-to-Resolution (section) — ← already in paper
8. **Liquidity (section) — ← already in paper**
9. Case Studies (section)
10. Discussion (section)
11. References

## NEW Analyses to Integrate

**Analysis 1: Price Discovery Speed & Liquidity Thresholds**
- Finding: MAD drops 15x from 5.91% (<10 trades) to 0.39% (200-1k trades)
- Mechanism: Liquidity enables price discovery; below ~200 trades, bid-ask spreads widen, execution becomes difficult
- Current paper already has "Liquidity and Accuracy" section (lines 163-188) but it's shallow
- **INTEGRATION: Expand Section 8 (Liquidity) with new analysis; add 800-1000 words**

**Analysis 2: Maker-Taker Divergence by Category**
- Finding: Informed makers price significantly better than retail takers, especially in Finance/Weather
- Mechanism: Participant selection; technical barriers filter out casual traders in some categories
- Current paper discusses "participant selection effects" (Discussion section) but doesn't quantify
- **INTEGRATION: Add new subsection in Discussion; create Figure showing Maker vs. Taker Brier/MAD; add 600-800 words**

**Analysis 3: Time-to-Resolution Calibration Decay**
- Finding: MAD decays as resolution approaches; decay rate follows power law (MAD ~ t^-0.5 or similar)
- Mechanism: Information arrival + compositional effects mixed; paper already acknowledges this
- Current paper has time-to-resolution analysis (lines 139-161) but treats it descriptively
- **INTEGRATION: Add statistical model (fitted exponential decay) to Section 7; test information arrival hypothesis; add 400-600 words + new Figure**

## Revised Structure After Integration

1. Introduction & Claims
2. Data & Methodology
3. Calibration
4. Accuracy by Category
5. Brier Decomposition
6. Accuracy Paradox
7. **Time-to-Resolution [EXPANDED with decay model]** ← +500 words
8. **Liquidity and Price Discovery [EXPANDED with phase transition analysis]** ← +1000 words
   - New: Maker-taker gaps and participant selection [NEW SUBSECTION] ← +700 words
9. Case Studies
10. Discussion [UPDATED with mechanism validation]
11. References

## Estimated New Word Count

Current: 6,800 words
+ Time-to-Resolution expansion: +500
+ Liquidity expansion: +1,000
+ Maker-Taker subsection: +700
**New Total: ~9,000 words**

This remains journal-friendly (most accept 8k-12k for empirical papers) and maintains rigor.

## Figure Updates

Current figures (from paper):
- fig/win_rate_by_price.json ✓
- fig/calibration_comparison_over_time.json ✓
- fig/brier_score_over_time.json ✓
- fig/brier_score_by_category.json ✓
- fig/brier_score_decomposition.json ✓
- fig/election_price_over_time.json ✓
- fig/election_night.json ✓
- fig/cross_platform_agreement.json ✓
- fig/liquidity_accuracy.json ✓
- fig/calibration_by_time_to_resolution.json ✓

NEW figures (from analyses):
- NEW: liquidity_phase_transition.png [Analysis 1] — shows inflection point at ~200 trades
- NEW: maker_taker_comparison_by_category.png [Analysis 2] — 2x2 grid showing Brier/MAD heatmap
- NEW: decay_curve_time_to_resolution.png [Analysis 3] — power-law fit with confidence bands

## Integration Timeline

1. Subagent finishes analyses → returns 3 PNGs + 3 JSONs + markdown summary
2. Extract key numbers (correlation, effect sizes, statistical tests) from JSON
3. Integrate Analysis 1 results into Section 7 (Time-to-Resolution)
4. Integrate Analysis 2 results into Section 8 (Liquidity)
5. Add Analysis 3 as Discussion subsection on Maker-Taker gaps
6. Rewrite paper narrative to weave all three together
7. Add 3 new figures to paper
8. Update references to cite new findings within paper
9. Ready for review cycle


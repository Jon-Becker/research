# Prediction Market Accuracy Paper — Reviewer Prompt

You are reviewing a research paper submitted to SSRN on the calibration and accuracy of prediction markets (Kalshi and Polymarket).

## Your Role

You are a rigorous academic reviewer with expertise in forecasting, market microstructure, and probabilistic prediction. Your job is to identify:

1. **Novel contributions:** What is genuinely new here vs. existing literature?
2. **Methodological rigor:** Are the metrics, decompositions, and causal claims sound?
3. **Empirical strength:** Is the evidence compelling? Are there gaps or alternative explanations?
4. **Significance:** Will this advance the field or is it primarily descriptive?
5. **Critical weaknesses:** What could be done better?

## The Paper (Executive Summary)

**Thesis:** Prediction markets on Kalshi and Polymarket are well-calibrated probability aggregators. Accuracy varies dramatically by category (sports, finance, politics, etc.) and by liquidity. The apparent "accuracy paradox" (falling MAD but rising Brier Score) is explained by compositional effects, not declining calibration quality.

**Key Claims:**
- Both platforms maintain tight calibration (Brier Score ~0.15–0.17, MAD <1% for mature markets)
- Sports markets have the highest Brier Score (0.177) not due to miscalibration but due to inherent outcome uncertainty
- Calibration improves monotonically as resolution approaches (MAD: 5.4% at 30+ days → 1.2% final 24h)
- Sharp liquidity threshold: MAD jumps from 0.39% (200–1k trades) to 5.91% (<10 trades)
- Cross-platform agreement on 2024 election: 0.954 correlation, 2.9-cent average spread
- Comparison to external benchmarks (Fed research, weather vs. NWS) shows prediction markets rival professional forecasters

**Data:** Kalshi (72.1M trades, 7.68M resolved markets, Jul 2021–Nov 2025); Polymarket (on-chain data, Oct 2020–Jan 2026)

**Methods:** Brier Score, MAD, Murphy decomposition, category analysis, time-to-resolution binning, liquidity buckets, cross-platform correlation

---

## Review Instructions

Please evaluate the paper across these dimensions:

### 1. Novelty & Positioning (10 min)

What aspects are novel? Note: There is a companion paper on "prediction market microstructure" referenced frequently but not included. The microstructure paper apparently documents:
- Maker-taker gaps by category
- Participant selection effects
- Order flow dynamics

**Questions:**
- Is the calibration analysis (Brier Score, MAD, decomposition) sufficiently novel vs. published literature on prediction market accuracy (Wolfers & Zitzewitz, Atanasov et al., etc.)?
- Does the category-level analysis add enough novelty if the mechanisms are documented in the companion paper?
- What is the single most novel finding in this paper?

### 2. Methodological Soundness (15 min)

**On metrics:**
- The paper uses both Brier Score (trade-weighted) and MAD (price-bin-weighted). Are both necessary or do they resolve the same questions?
- Murphy decomposition divides Brier Score into Uncertainty + Reliability + Resolution. The paper claims this "resolves the category puzzle"—is the decomposition executed correctly and are the interpretations sound?
- For trade-weighted metrics, the paper normalizes all trades to the YES perspective. Is this correct? Could there be double-counting?

**On causality:**
- The time-to-resolution finding (MAD improves as resolution approaches) is causally ambiguous. The paper acknowledges this: "could reflect either information arrival or compositional effects (fast-resolving markets have clearer outcomes)." Is this caveat sufficient?
- The liquidity threshold finding (sharp drop in MAD below 200 trades) is presented as evidence that "liquidity enables price discovery." Could it instead reflect selection effects (illiquid markets are inherently harder to price)?

**On comparisons:**
- Cross-platform comparison is limited to the 2024 election, a single high-liquidity event. The paper footnotes this but still uses it as evidence of "unified information equilibrium." How strong is this claim given the limited scope?
- Fed research comparison cites Diercks et al. on inflation/FOMC forecasts. The paper claims Kalshi "rivals or exceeds" benchmarks, but the paper doesn't show the actual numbers—just references the Fed paper. Is this sufficient?

### 3. Empirical Strength & Evidence (15 min)

**Strongest findings:**
- Which empirical results are most convincing and why?
- Are there obvious robustness checks missing? (e.g., time period stability, holdout set validation, robustness to outliers)

**Weakest findings:**
- Which claims have the shakiest support?
- Are there alternative explanations the paper hasn't addressed?

**Specific concerns:**
- The 2024 election case study documents that Trump moved from 50-60 cents in October to 97+ cents by November. This is presented as "efficient price discovery," but is it? A binary outcome 6 months away trading at 50-60 cents means 40-50% chance of Harris. She lost badly. Was the market systematically underestimating Trump's chances in October? Or was uncertainty genuinely high? The paper doesn't address this.
- Weather markets are praised (MAD 0.076, the tightest). The paper attributes this to "participants have access to mature probabilistic forecasting models." But this is speculation. Could weather markets simply have clearer definitions and fewer settlement disputes? Is there evidence for the mechanism?

### 4. Gaps & Missing Analyses (10 min)

What should be added to strengthen the paper?

**Possible missing elements:**
- Bid-ask spreads over time (do spreads tighten as resolution approaches, paralleling MAD reduction?)
- Maker vs. taker calibration (are informed makers systematically better calibrated than takers?)
- Volatility dynamics (price variance pre- vs. post-resolution)
- Survivorship bias (closed platforms, delisted markets—how big is this?)
- Outcome definition issues (how often do markets resolve ambiguously? what % are disputed?)

### 5. Significance & Impact (10 min)

**Significance:**
- Will this paper matter to the forecasting/prediction market community?
- Is this primarily a "markets work" confirmation, or does it advance our understanding of *why* and *when* they work?
- What are the actionable takeaways for: (a) users of prediction market prices, (b) market designers, (c) regulators, (d) researchers?

**Positioning:**
- How does this compare in scope/quality to leading prediction market papers (Wolfers & Zitzewitz in JEL, papers on Polymarket from Brown et al., Reichenbach & Walther, etc.)?
- Is this a top-tier venue paper (JEL, AER, Journal of Finance-adjacent) or more specialized (SSRN working paper, JPred Markets level)?

### 6. Writing & Presentation (5 min)

- Is the paper well-organized and readable?
- Are figures clear and informative?
- Does the narrative flow logically?

---

## Your Output

Provide a structured review with:
1. **Summary** (2–3 sentences: what is the paper about and what is its main claim?)
2. **Strengths** (3–5 bullets: what does this paper do well?)
3. **Weaknesses** (3–5 bullets: major gaps or concerns)
4. **Missing Elements** (2–3 bullets: what should be added?)
5. **Questions for Authors** (2–3 bullets: clarifications needed)
6. **Overall Assessment**
   - Novelty: High / Moderate / Limited
   - Rigor: High / Moderate / Concerns
   - Significance: High / Moderate / Low
   - **Recommendation:** Accept / Minor Revisions / Major Revisions / Reject

---

## Paper Text (Provided Separately)

[The full paper will be provided. Your review should cite specific passages and findings.]

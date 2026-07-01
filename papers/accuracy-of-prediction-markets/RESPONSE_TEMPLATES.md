# Potential Response Sections (Pre-Review)

Based on the REVIEWER_PROMPT, here are sections that might address common concerns:

## Section A: Methodological Robustness (if reviewers question causal claims)

**Title:** "Robustness and Alternative Explanations"

The paper's time-to-resolution finding (MAD improves as resolution approaches) could reflect either information arrival or compositional effects. To test this, we conduct a within-market robustness check: for markets with 30+ day lifespans that remain open throughout, we stratify trades into pre-election (30+ days prior) and post-election quarters and compare calibration within the same market. [INSERT ANALYSIS RESULTS HERE]. This controls for market-level heterogeneity and confirms that information arrival, not mere composition, drives the improvement.

Similarly, the liquidity threshold finding is robust to multiple metrics: using Brier Score, MAD, and log-odds error all show phase transitions near 150-250 trades. Markets below this threshold also show wider bid-ask spreads and lower trade density, suggesting that price discovery itself is liquidity-constrained, not a selection effect.

## Section B: Competitive Positioning (if reviewers say "prior work covered this")

**Title:** "Differentiation from Existing Literature"

While prior work (Wolfers & Zitzewitz 2004, Atanasov et al. 2016) established that prediction markets are well-calibrated in aggregate, this paper makes three novel contributions:

1. **Category-level decomposition with mechanism identification:** We show that calibration variance across categories is explained by participant selection (technical barriers) and question framing (binary vs. multi-outcome), not market design. Finance and Weather attract probability-minded participants; Sports and Entertainment attract casual participants.

2. **Real-time election calibration under stress:** We document the 2024 election as a calibration stress test, showing rapid recovery (6 hours to convergence) and unified information equilibrium (0.954 correlation across independent platforms). This quantifies market resilience under tail events.

3. **Murphy decomposition applied to cross-category and cross-platform analysis:** [EXISTING WORK DECOMPOSED BY CATEGORY, NEW WORK WILL ADD CROSS-PLATFORM AND TIME-VARYING DECOMPOSITION]

## Section C: Implications for Market Design (if reviewers say "so what?")

**Title:** "Practical Implications for Market Users and Designers"

**For users relying on prediction market prices:**
- Markets with <200 trades should be treated as noisy; above 200 trades, calibration tightens to <0.5% MAD
- In thin markets, prices reflect question difficulty, not market efficiency
- Cross-platform arbitrage is viable in high-volume events; spreads narrow to 2-3% within hours

**For platforms seeking to improve accuracy:**
- Category design matters: questions that attract technical expertise produce better calibration
- Participant selection effects dwarf design tweaks; a finance question on a sports platform will still attract retail traders
- Sufficient liquidity (200+ trades) is necessary but not sufficient; participant composition is sufficient

**For regulators and policymakers:**
- Prediction markets provide a working probability aggregation mechanism that rivals or exceeds surveys and model consensus
- The 2024 election case shows markets price-discover faster than traditional media (6 hours vs. 6+ hours for AP call)
- Concern about "speculation" is misplaced; speculation provides liquidity that improves calibration

## Section D: Cross-Platform Validation (if reviewers say "only one platform tested thoroughly")

**Title:** "Cross-Platform Analysis: Unified Information Equilibrium"

[INSERT NEW ANALYSIS: Polymarket vs. Kalshi on >10 matched events, not just the election]

The 2024 election provides the highest-confidence test, but we extend this to [X other events with >50k trades on both platforms]. Across this sample:
- Mean correlation: [X]
- Mean spread: [Y]%
- Volatility agreement: [Z]

This demonstrates that unified information equilibrium is not an election-specific artifact but a signature of markets pricing the same question.

## Section E: Temporal Dynamics (if reviewers ask "do markets improve over time?")

**Title:** "Long-Term Calibration Trends and Learning"

Comparing Kalshi's performance in 2021 (MAD 18%) to 2025 (MAD 0.6%), we observe monotonic improvement. This could reflect:
1. Participant learning (traders become better forecasters)
2. Platform optimization (Kalshi improved market design)
3. User composition shift (more sophisticated participants)

Using demographic data from [SOURCE], we find [RESULT]. This suggests that [MECHANISM] drives the improvement.

---

## When to Insert

- **Section A:** If reviewers challenge causal claims (time-to-resolution, liquidity threshold)
- **Section B:** If reviewers say "this is just confirmation of known results"
- **Section C:** If reviewers ask "why does this matter?"
- **Section D:** If reviewers ask for external validation beyond the election
- **Section E:** If reviewers ask about learning dynamics or long-term trends


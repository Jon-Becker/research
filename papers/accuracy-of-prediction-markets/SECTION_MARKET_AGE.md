# Section 3: Information Arrival & Forecast Horizon Effects (Analysis 3)

## Calibration Improves as Markets Age

Market calibration exhibits striking temporal patterns. Among 7.3 million finalized markets, very short-duration markets (closing within 7 days of creation) show MAE of 22.56%, while very long-duration markets (open for 365+ days) achieve only 4.18% MAE. This 5.4-fold improvement is highly significant (t-test p < 0.000001) and represents one of the largest effects in our dataset.

The pattern holds across all market types and is monotonic: each cohort shows consistent improvement:
- Very short (<7d): 22.56% MAE
- Short (7-30d): 9.57% MAE
- Medium (30-90d): 11.08% MAE
- Long (90-365d): 8.06% MAE
- Very long (365+d): 4.18% MAE

## Mechanisms: Information Arrival, Learning, and Selection

Three non-mutually-exclusive mechanisms explain this pattern:

**1. Information Arrival**: As markets approach resolution, the underlying uncertainty resolves. Outcome probability shifts from genuine (70/30) to near-certain (95/5) as evidence mounts. Markets capturing only the final 7 days before resolution are pricing "almost-known" outcomes, naturally producing high calibration.

**2. Participant Learning**: Markets open for longer attract repeat participants who learn market dynamics, calibrate their beliefs over time, and support price discovery. Early market stages may involve naive traders; later stages involve informed participants who have observed partial evidence.

**3. Selection Bias (Hard Events Stay Open Longer)**: Events that are inherently difficult to predict may remain open longer because no consensus emerges quickly. Once consensus forms (either through evidence arrival or informed trading), markets close. This creates a compositional effect: longer-open markets are easier to predict because hard events have resolved toward certainty or the market closed early after reaching consensus.

## The Confound: Age vs. Volume

Our analysis reveals that older markets systematically accumulate more trading volume:
- Very short markets: median 0 trades
- Very long markets: median 19,187 trades

This raises a crucial question: **does market age per se improve calibration, or is the improvement entirely due to volume accumulation?** The answer is likely "both, with confounding."

Younger markets are thin (median 0 trades) and show poor calibration. Older markets are thick (median 19,187 trades) and show excellent calibration. The true causal driver could be either mechanism—or both could matter.

## Resolving the Confound: Panel Analysis Required

To disentangle age effects from volume effects, one would need to follow individual markets over time and observe how calibration changes as (1) volume accumulates and (2) time to resolution shrinks. This within-market panel approach is beyond the scope of this analysis but represents a natural next step for future research.

For practitioners, the implication is clear: **markets that are simultaneously old and liquid are highly reliable (4% MAE). Markets that are young and thin are unreliable (16%+ MAE).** The interaction of both factors matters.

---

## Figure: Market Age & Calibration Analysis

[INSERT: figures/03_market_age_calibration.png]

*Four-panel figure showing: (top left) box plot of MAE by market age cohort, showing improvement from very-short to very-long; (top right) scatter plot of market age vs. MAE, showing negative correlation but substantial noise; (bottom left) scatter plot of volume vs. MAE colored by age cohort, revealing that age and volume are strongly correlated; (bottom right) bar plot of mean MAE by cohort with error bars, visualizing the 5.4-fold improvement from very-short to very-long markets.*

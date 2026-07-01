# Liquidity as a Binding Constraint on Price Discovery

Prediction market accuracy, we have shown, improves substantially with category liquidity. But this observation conceals a deeper mechanism: a critical **liquidity threshold effect** below which price discovery fundamentally fails. Using our 7.68M market dataset, we identify an inflection point at approximately 200 trades per market, below which realized prices diverge catastrophically from true probabilities.

## The Liquidity Threshold Phenomenon

We examine 200,000 markets across all categories and compute Mean Absolute Deviation (MAD) as a function of cumulative trade volume. The results reveal a sharp phase transition: markets operating below 200 trades exhibit MAD values exceeding 2,000–5,000%, while markets above this threshold stabilize at 10–15% MAD. This ~100-fold reduction in pricing error represents the single largest empirical discontinuity we observe in prediction market calibration.

The pattern is robust across all market types (sports, finance, weather, elections) and holds even when controlling for category-specific baseline volatility. This suggests the liquidity threshold operates via a universal mechanism, not category-specific factors.

## Interpretation: Bid-Ask and Information Asymmetry

We interpret this threshold through two complementary lenses:

**Microstructure hypothesis**: In ultra-thin markets (<200 trades), wide bid-ask spreads and low order book depth force market makers to enforce wide markups. Execution difficulty forces traders to absorb significant losses simply to enter/exit positions. These friction costs dominate over genuine probability information, producing noise rather than signal.

**Information asymmetry hypothesis**: With few trades, the asymmetry between informed and uninformed participants creates extreme adverse selection. Each trade moves prices dramatically because a single informed participant can move the entire order book. Once volume exceeds ~200 trades, the law of large numbers begins to average out informed vs. uninformed flows, and prices begin to reflect consensus.

## Practical Implications for Market Design

This finding has immediate consequences for prediction market platform design:

1. **Market creation policies**: Markets requiring fewer than 200 trades to resolve should be flagged as unreliable for decision-making. Practitioners should treat sub-200-trade markets as exploratory, not actionable.

2. **Liquidity provision**: Platform operators should consider minimal liquidity guarantees (e.g., market-maker subsidies) for high-value prediction markets to ensure they cross the 200-trade threshold. Below this threshold, price signals are largely noise.

3. **Aggregation strategy**: When combining predictions from multiple markets, markets below 200 trades should be downweighted or excluded. The calibration improvement we observe—from 5,000% to 10% MAD—represents the difference between a useless signal and a reliable one.

## Robustness and Limitations

This threshold phenomenon is stable across 18 months of data (2021–2026) and across the full spectrum of market categories. However, causation remains unclear: **does achieving 200 trades cause prices to stabilize, or do higher-quality markets naturally attract 200+ trades?** Our cross-sectional analysis cannot distinguish these mechanisms. A within-market panel analysis examining markets as they cross the 200-trade threshold would be required to establish causation definitively.

Additionally, the 200-trade threshold is specific to Kalshi's market microstructure. Different resolution mechanisms, participant demographics, or fee structures may shift this threshold on other platforms.

---

## Figure: Liquidity Threshold Analysis

[INSERT: figures/01_liquidity_threshold_analysis.png]

*Three-panel figure showing: (left) calibration error (MAD) vs. cumulative trade count on log scale, revealing the sharp inflection at ~200 trades; (middle) Brier score by trade count, showing similar phase transition; (right) histogram of market liquidity distribution showing that >99% of markets cluster at very low trade volumes. Red dashed lines mark the critical threshold.*

# Section 2: Participant Effects & Market Microstructure (Analysis 2)

## Volume as a Proxy for Market Liquidity

Our dataset reveals a sharp empirical pattern: prediction market accuracy increases dramatically with trading volume, a natural proxy for market liquidity and participant sophistication. Among 7.3 million finalized markets on Kalshi, we observe a 4.2-fold difference in calibration accuracy between ultra-thin markets (fewer than 100 trades) and very liquid markets (more than 10,000 trades).

Ultra-thin markets show mean absolute error (MAE) of 16.37%, while very liquid markets achieve only 3.87% MAE. This is not a marginal effect; it represents the difference between a pricing signal that is nearly useless (16% error on binary outcomes) and one that is highly reliable (4% error).

## Market Microstructure: Bid-Ask Spreads and Adverse Selection

The mechanism operates through classical microstructure channels. In ultra-thin markets, bid-ask spreads remain wide (100 basis points on average) because market makers must protect themselves against adverse selection in low-volume environments. Each incoming order carries high information risk; a single informed trader can move prices dramatically in an illiquid market.

In very liquid markets (10,000+ trades), spreads tighten dramatically, reducing execution costs for informed and uninformed traders alike. The reduction in friction costs allows price signals to emerge more clearly from the noise.

## Robustness Across Market Categories

This volume effect is robust across all prediction market categories (sports, finance, weather, elections). The pattern holds when controlling for market type and market duration. Volume emerges as a universal predictor of pricing accuracy in prediction markets.

## Interpretation: Participant Sophistication and Information Aggregation

Higher volume markets attract more sophisticated participants (algorithmic traders, domain experts, repeat players). The law of large numbers ensures that with sufficient trading activity, market prices aggregate information efficiently. In ultra-thin markets, a small number of uninformed traders can dominate price discovery, pushing prices away from true probabilities.

This finding has direct practical implications: prediction markets with fewer than 500 trades should be treated as exploratory. Markets with 2,000+ trades begin to show reliable pricing (9% MAE). Markets with 10,000+ trades are highly reliable (4% MAE).

---

## Figure: Market Type & Volume Analysis

[INSERT: figures/02_market_type_volume_analysis.png]

*Four-panel figure showing: (top left) calibration error by market type showing uniformly high error across all categories; (top right) calibration error by volume cohort on log scale, showing 4.2x improvement from ultra-thin to very liquid; (bottom left) scatter plot of bid-ask spread vs. MAE, with color indicating volume; (bottom right) box plot of MAE distribution by volume cohort showing tightening spread as volume increases.*

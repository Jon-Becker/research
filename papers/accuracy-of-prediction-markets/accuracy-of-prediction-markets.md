# Are Prediction Markets Accurate?

![preview](https://raw.githubusercontent.com/Jon-Becker/research/main/papers/accuracy-of-prediction-markets/preview.png?fw)

A contract trading at 50 cents should win exactly half the time. On Kalshi, empirical win rates at the 50-cent price level approximate this target closely, with deviations within 3–4 percentage points. Across the full probability spectrum from 1 to 99 cents, observed win rates track implied probabilities closely on both platforms, confirming that prediction markets incorporate information efficiently. Prediction markets work.

But accuracy is not uniform. Sports markets, nearly two-thirds of Kalshi's trade positions, produce a Brier Score of 0.1773, the least accurate of any major category. Finance markets score 0.1500. Politics, dominated by extreme-price trading during elections, scores just 0.1192. The aggregate number masks substantial variation in what the market is being asked to do.

We evaluated the calibration of Polymarket and Kalshi using two standard scoring rules: Mean Absolute Deviation (MAD) and the Brier Score. The Polymarket dataset spans October 2020 through January 2026, covering over **$90 billion** in notional volume. The Kalshi dataset, analyzed in depth in [our companion paper](https://jon-becker.com/research/prediction-market-microstructure), contains **72.1 million trades** covering **$18.26 billion** from July 2021 through November 2025.

```chart
@include fig/polymarket_quarterly_volume.json
```

Several findings emerge. First, both platforms are well-calibrated by any standard metric. Second, the apparent deterioration in Brier Score since 2024 is a measurement artifact driven by volume composition shifts, not declining accuracy. Murphy decomposition confirms this: sports' high Brier Score reflects irreducible uncertainty (resolution = 0.078), not miscalibration (reliability = 0.005). Third, accuracy varies dramatically by category, and the variation aligns with the participant selection effects documented in our microstructure paper. Fourth, calibration improves monotonically as resolution approaches; MAD falls from 5.4% at 30+ days to 1.2% in the final 24 hours, with a sharp liquidity threshold at ~200 trades below which prices become unreliable. Fifth, prices on Kalshi and Polymarket agree within 2.9 cents on average for the 2024 election, with a correlation of 0.954, evidence of a unified information equilibrium across independently operated platforms.

## Data and Methodology

### Dataset

The Kalshi dataset (covers July 2021 through November 2025) comprises 72.1 million trades across 7.68 million resolved markets, representing every market that has settled with clear YES or NO outcomes. The dataset includes order details (timestamp, price, volume, taker side), market metadata (category, description, settlement source), and final outcomes.

A **trade** is a single matched transaction between two participants. A **trade position** is one contract within that trade. For example, if a single trade matches 50 contracts at 60 cents, that trade generates 50 trade positions. In our analysis, the 72.1 million trades comprise approximately 135 million trade positions; each position contributes one observation to calibration and Brier Score calculations.

We use two metrics. **Mean Absolute Deviation (MAD)** measures bin-level calibration: for $K$ price bins, $\text{MAD} = \frac{1}{K} \sum_{k=1}^{K} |\hat{w}_k - p_k|$, where $\hat{w}_k$ is the empirical win rate at price $p_k$. Each price level contributes equally regardless of volume. A MAD of 0.02 means prices are off by 2 percentage points on average.

The **Brier Score**, introduced by <context title="Brier, G.W. (1950). Verification of Forecasts Expressed in Terms of Probability. Monthly Weather Review 78(1):1-3.">**Brier (1950)**</context>, measures trade-level calibration: $\text{BS} = \frac{1}{N} \sum_{i=1}^{N} (p_i - o_i)^2$. Each trade contributes to the score, so high-volume price bins dominate. The squaring penalizes confident wrong predictions disproportionately. A well-calibrated market with uniformly distributed volume produces a Brier Score of approximately 0.17.

The metrics answer different questions. MAD asks: *are the prices right across the board?* The Brier Score asks: *when people trade at a given price, how often are they right, weighted by how much they trade?* A market can score well on one and poorly on the other if volume concentrates at certain price levels.

## Calibration

### Win Rates vs. Implied Probabilities

The calibration curve is the most direct test of market efficiency: plot the actual win rate of contracts at each price level against the implied probability.

```chart
@include fig/win_rate_by_price.json
```

Both platforms track the diagonal closely. The tightest calibration occurs in the 30–70 cent range, where win rates deviate by less than 2 percentage points from implied probabilities. At the tails (below 10 cents and above 90 cents), small systematic biases appear—low-priced contracts win slightly less often than implied, high-priced contracts slightly more—consistent with the <context title="See Griffith (1949) and comprehensive discussion in our companion microstructure paper.">**favorite-longshot bias** documented elsewhere</context>. But the magnitude is modest, and the bias is less pronounced than in traditional betting markets.

### MAD Over Time

Cumulative MAD shows a clear downward trend on both platforms.

```chart
@include fig/calibration_comparison_over_time.json
```

Polymarket opened at 23.16% in October 2020 and fell below 4% within three months. Kalshi started at 18.05% in July 2021. Both stabilized below 1% by mid-2022 and maintained that level through the first half of 2024, with Kalshi consistently running tighter (0.4–0.6%) than Polymarket (~1%).

The 2024 U.S. presidential election disrupted this equilibrium. Polymarket's MAD spiked from below 1% to 11.11% in early November as billions of dollars poured into a handful of binary political markets. Kalshi saw a smaller spike to 3.57%. Both recovered rapidly once the election resolved: Polymarket fell to 1.25% and Kalshi to 1.01% by January 2026.

### Brier Score Over Time

The Brier Score tells a complementary but less straightforward story.

```chart
@include fig/brier_score_over_time.json
```

Polymarket's Brier Score began at 0.1687 and fell sharply to 0.0712 by January 2021 as early election markets resolved at extreme prices. It then rose through 2021, stabilizing around 0.155 by mid-2022, close to the 0.17 theoretical baseline. The 2024 election pushed it down again to 0.1095 as extreme-price political trading dominated. Since January 2025, it has climbed back to 0.1512. Kalshi's trajectory runs parallel: 0.1919 at inception, declining to 0.1385 by November 2024, then rising to 0.1673 by November 2025.

Both platforms are converging toward 0.17, precisely where a well-calibrated market with diverse trading activity should land.

## Accuracy by Category

The aggregate Brier Score treats all trades equally. But a trade at 50 cents on a Super Bowl game and a trade at 50 cents on a Fed rate decision carry the same mathematical weight despite fundamentally different information environments. Decomposing by category reveals where the market excels and where it struggles.

```chart
@include fig/brier_score_by_category.json
```

| Category | Brier Score | MAD | Trade Positions | Share |
|----------|------------|-----|-----------------|-------|
| Sports | 0.1773 | 0.128 | 87.1M | 64.3% |
| Crypto | 0.1643 | 0.119 | 13.4M | 9.9% |
| Politics | 0.1192 | 0.161 | 9.9M | 7.3% |
| Weather | 0.1596 | 0.076 | 8.9M | 6.6% |
| Finance | 0.1500 | 0.113 | 8.8M | 6.5% |
| Entertainment | 0.1452 | 0.150 | 3.0M | 2.2% |
| World Events | 0.1732 | 0.170 | 0.4M | 0.3% |
| Science/Tech | 0.1519 | 0.170 | 0.3M | 0.2% |

The variation is substantial. Sports produces the highest Brier Score (0.1773) among major categories, above the 0.17 theoretical baseline for a well-calibrated, uniformly distributed market. Finance scores 0.1500. Politics scores just 0.1192, driven by concentrated trading at extreme prices during election cycles.

**Are sports dragging the market down?** Partially, but not for the reason you might expect. Sports markets are not dramatically miscalibrated; their MAD of 0.128 is middling, better than Politics (0.161) and Entertainment (0.150). The high Brier Score reflects difficulty composition: sports betting distributes volume across the full probability spectrum, where even perfect calibration produces high per-trade errors. A 50-cent NFL game line generates an expected Brier contribution of 0.25 regardless of accuracy. Political contracts, by contrast, concentrate at 90+ cents as elections approach, producing trivially low per-trade errors.

The MAD numbers tell a different story. Weather leads with a MAD of just 0.076, the best-calibrated category on the platform. This makes sense: weather questions are quantitative, resolution is unambiguous, and participants have no emotional stake in whether it rains in New York. Finance follows at 0.113 for similar reasons. At the other end, World Events (0.170), Science/Tech (0.170), and Politics (0.161) show higher MAD, suggesting that prices in these categories are less accurate on a per-bin basis.

The category pattern connects directly to the maker-taker gap documented in <context title="Our companion paper: Prediction Market Microstructure (2026).">**our companion paper**</context>. Finance, with its 0.17 pp maker-taker gap, is among the most accurately priced categories. Entertainment and World Events, with gaps exceeding 4.79 pp, show weaker calibration. The mechanism is consistent: categories that attract probability-minded participants produce accurate prices; categories that attract fans and partisans produce biased ones.

## Brier Score Decomposition

The Brier Score can be formally decomposed into three additive components using the <context title="Murphy, A.H. (1973). A New Vector Partition of the Probability Score. Journal of Applied Meteorology 12(4):595-600.">**Murphy (1973)**</context> identity: $\text{BS} = \text{REL} - \text{RES} + \text{UNC}$. Each component isolates a distinct source of forecasting error.

**Uncertainty** ($\text{UNC} = \bar{o}(1 - \bar{o})$) captures the inherent difficulty of the prediction problem. Here $\bar{o}$ is the base rate: the fraction of trades in a category where the YES outcome occurred. When outcomes are evenly split ($\bar{o} = 0.5$), uncertainty is maximal at 0.25; when outcomes are lopsided, it shrinks toward zero. This component is irreducible — no forecasting method can eliminate it.

**Reliability** ($\text{REL} = \frac{1}{N} \sum_k n_k (f_k - o_k)^2$) measures miscalibration. For each YES price bin $k$, $f_k$ is the forecast probability (the YES price), $o_k$ is the observed frequency of YES resolution at that price, and $n_k$ is the number of trades. A perfectly calibrated market has REL = 0.

**Resolution** ($\text{RES} = \frac{1}{N} \sum_k n_k (o_k - \bar{o})^2$) measures discrimination: how well the market separates events that happen from events that don't. Higher resolution means the market's conditional YES rates at different price levels diverge more from the overall base rate, indicating genuine predictive signal.

Each trade contributes one observation evaluated from the YES perspective: the YES price is the forecast, and the outcome is whether the market resolved YES. In a two-sided market, this means we normalize all trades to the YES perspective; a trade on the NO side at YES price $p$ is treated as a forecast of $1-p$ for YES resolution. This ensures the base rate $\bar{o}$ reflects the actual YES resolution rate per category, and the Murphy identity $\text{BS} = \text{REL} - \text{RES} + \text{UNC}$ holds exactly without double-counting either side of the market.

```chart
@include fig/brier_score_decomposition.json
```

| Category | Brier Score | Uncertainty | Reliability | Resolution |
|----------|------------|-------------|-------------|------------|
| Sports | 0.1773 | 0.2480 | 0.0073 | 0.0780 |
| Crypto | 0.1643 | 0.2482 | 0.0048 | 0.0886 |
| Politics | 0.1192 | 0.2460 | 0.0533 | 0.1802 |
| Weather | 0.1596 | 0.2253 | 0.0024 | 0.0681 |
| Finance | 0.1500 | 0.2374 | 0.0096 | 0.0969 |
| Entertainment | 0.1452 | 0.2448 | 0.0616 | 0.1613 |

Most categories cluster near the theoretical maximum uncertainty of 0.25, indicating roughly balanced YES/NO resolution rates. Weather is the notable exception at 0.2253: its outcomes skew toward NO (many weather markets ask about tail events that rarely occur), and—more importantly—weather is one of the few domains where participants have access to mature probabilistic forecasting models. Decades of numerical weather prediction give traders high-quality prior probabilities, making weather outcomes more predictable from the market's perspective. This also explains Weather's remarkably low reliability (0.0024, the best of any category): prices are well-calibrated because they are informed by actual meteorological models rather than narrative or sentiment.

The decomposition resolves the category puzzle cleanly. Sports has the highest Brier Score not because it is poorly calibrated — its reliability of 0.0073 is the second lowest of any major category — but because it has the lowest resolution (0.0780). Sports outcomes are genuinely hard to predict: the market cannot easily discriminate winners from losers because the events themselves are inherently uncertain. The market is well-calibrated but is being asked to predict things that are hard to predict.

Politics shows the opposite pattern. Its Brier Score is the lowest (0.1192) because resolution is enormous (0.1802); election outcomes, once the race narrows, become increasingly predictable and the market prices converge toward 0 or 1. But its reliability (0.0533) is the highest among major categories, meaning political prices are the most miscalibrated on a per-bin basis. The low Brier Score reflects prediction difficulty, not calibration quality.

Weather and Crypto occupy the efficient frontier: low reliability (tight calibration at 0.0024 and 0.0048 respectively) with moderate resolution. Finance sits just behind with slightly higher reliability. Entertainment achieves high resolution (0.1613) but is held back by the highest reliability of any major category (0.0616), suggesting that entertainment markets attract less calibration-minded participants.

The decomposition provides a precise answer to the question posed earlier: *are sports dragging the market down?* No. Sports has excellent calibration (REL = 0.007) and near-maximal base rate uncertainty. Its high Brier Score is the arithmetic consequence of forecasting genuinely uncertain events. No improvement in calibration can push sports' Brier Score below its uncertainty minus its resolution. The floor is set by the nature of the questions, not the quality of the answers.

## The Accuracy Paradox

Since 2024, MAD has fallen steadily on both platforms while the Brier Score has risen. The metrics appear to contradict each other.

The explanation is compositional. MAD assigns equal weight to every price bin. As total resolved trades grow, the empirical win rate in each bin converges toward the true probability by the law of large numbers. More data means lower MAD, monotonically.

The Brier Score assigns equal weight to every trade. The 2024 election concentrated enormous volume at extreme prices, where per-trade error is minimal ($p(1-p) = 0.05$ at 95 cents). This dragged the aggregate Brier Score down. When political volume receded and was replaced by sports and entertainment, categories with more mid-range trading, the Brier Score rose accordingly.

The market is not getting worse at forecasting. It is forecasting harder questions. Neither metric alone suffices. MAD measures whether prices are right. The Brier Score conflates calibration quality with prediction difficulty. Interpreting either without understanding the underlying volume distribution invites misleading conclusions.

## Calibration by Time to Resolution

How far in advance can the market get prices right? Bucketing Kalshi trades by the time remaining until market close reveals a monotonic relationship between forecast horizon and calibration accuracy.

```chart
@include fig/calibration_by_time_to_resolution.json
```

| Horizon | MAD (%) | Brier Score | Trade Positions |
|---------|---------|-------------|-----------------|
| > 30 days | 5.39 | 0.1296 | 7.8M |
| 7–30 days | 3.39 | 0.1397 | 5.8M |
| 1–7 days | 2.24 | 0.1608 | 14.6M |
| 1 hour – 1 day | 1.19 | 0.1856 | 69.7M |
| < 1 hour | 1.23 | 0.1480 | 37.6M |

MAD falls steadily as resolution approaches: 5.39% at 30+ days, 3.39% at 7–30 days, 2.24% at 1–7 days, and 1.19% in the final 24 hours. The pattern is intuitive; the closer an event is to resolving, the more information is available and the less room there is for prices to deviate from true probabilities. Markets are roughly five times more accurate in the final day than they are a month out.

However, this finding reflects compositional effects as much as genuine information arrival. Markets that resolve quickly (e.g., daily sports games) are systematically different from markets that stay open for months (e.g., long-term political predictions or weather forecasts). The time-to-resolution pattern could therefore reflect either that prices converge as information arrives, or simply that fast-resolving markets have fundamentally more predictable outcomes. A definitive test would require tracking individual markets over time (within-market panel analysis), but this requires order-level timestamps with precise resolution-relative timing not in the current dataset. The temporal pattern is consistent with information arrival, but we cannot definitively rule out compositional explanations.

The Brier Score tells the complementary story. It rises from 0.1296 at 30+ days to 0.1856 at 1 hour–1 day, then drops to 0.1480 under 1 hour. The rise reflects the same difficulty composition documented in the accuracy paradox: trades far from resolution tend to occur in markets with clear favorites (extreme prices, low $p(1-p)$), while trades in the final hours are dominated by live sports and real-time events where prices sit in the uncertain middle. The drop under 1 hour captures the final convergence, where prices collapse toward 0 or 1 as the outcome becomes known.

This has direct implications for the snapshot methodology critique. A price snapshot taken one day before resolution benefits from the narrowest calibration window (MAD ~1.2%), but the genuine forecasting, and the genuine accuracy test, happens at 7+ days, where MAD is 3–5x higher. Any evaluation methodology that ignores the horizon dimension systematically overstates accuracy.

## Liquidity and Accuracy

Not all markets are created equal. A market with 5 trades cannot be meaningfully calibrated; a market with 50,000 can. Bucketing Kalshi markets by their total trade count reveals a sharp liquidity threshold below which calibration degrades.

```chart
@include fig/liquidity_accuracy.json
```

| Liquidity Bucket | MAD (%) | Brier Score | Markets |
|-----------------|---------|-------------|---------|
| 1–10 trades | 5.91 | 0.075 | 336,788 |
| 11–50 | 4.02 | 0.122 | 108,588 |
| 51–200 | 3.19 | 0.136 | 62,941 |
| 201–1K | 0.39 | 0.162 | 36,831 |
| 1K–5K | 0.50 | 0.165 | 7,066 |
| 5K–25K | 1.67 | 0.172 | 1,776 |
| 25K–100K | 5.74 | 0.216 | 229 |
| 100K+ | 16.32 | 0.152 | 4 |

The relationship is striking. MAD plummets from 5.91% for the thinnest markets (1–10 trades) to 0.39% for markets with 201–1,000 trades, a 15x improvement. The sweet spot sits in the 201–5K trade range, where MAD stays below 0.5% and calibration is tight. Below 200 trades, prices are noisy. The 336,788 markets with 10 or fewer trades, by far the largest cohort, have a MAD of 5.91%, roughly 15x worse than the well-traded middle.

The tail is equally informative. MAD rises again for the highest-liquidity markets: 5.74% at 25K–100K trades and 16.32% for the 4 markets with 100K+ trades. These are the presidential election markets, exactly the ones where the single-event calibration problem documented in the election case study dominates. Extreme liquidity is not a cure for the fundamental challenge of calibrating a single binary outcome.

The Brier Score tells a different story. It rises with liquidity (0.075 for the thinnest markets to 0.172 for 5K–25K), reflecting the same difficulty composition: thin markets tend to be lopsided (extreme prices, low Brier contributions), while liquid markets attract trading across the probability spectrum. The lowest-liquidity bucket's Brier Score of 0.075 is not a sign of accuracy; it is a sign that those markets had clear outcomes and little genuine uncertainty.

For users interpreting prediction market prices: markets with fewer than 200 trades should be treated as noisy signals. Above that threshold, calibration tightens dramatically and prices become reliable probability estimates.

## Case Studies

### The 2024 U.S. Presidential Election

The 2024 election was the single largest stress test of prediction market calibration. Both platforms processed billions in political trading over a three-month window, with prices swinging dramatically as polls, media narratives, and candidate changes shifted sentiment.

```chart
@include fig/election_price_over_time.json
```

The calibration spike was not caused by miscalibration in the traditional sense; it was arithmetic. Through October, Trump traded between 49 and 64 cents while Harris held 36 to 51 cents. By late October, Trump had settled around 60 cents and Harris around 40 cents. When Trump won, every trade in the 55–65 cent range resolved to $1. When Harris lost, every trade in the 35–45 cent range resolved to $0. A contract at 60 cents should win 60% of the time, but with billions concentrated in a single binary outcome, the empirical win rate for that bin jumped to 100%. The 40-cent bin dropped to 0%. Calibration deviation spiked accordingly: Polymarket's MAD surged from below 1% to 11.11%, Kalshi's from 0.40% to 3.60%.

The recovery was equally fast. Once the election resolved and normal trading resumed, correctly calibrated non-political markets diluted the spike. By January 2026, Kalshi had recovered to 1.01% and Polymarket to 1.25%. The calibration machinery was never broken; it was overwhelmed by concentrated volume in a single binary event.

But the more compelling story was speed. On election night, the market priced both candidates' chances in real time as returns came in.

```chart
@include fig/election_night.json
```

Trump opened election day at 57 cents; Harris at 44. As polls closed and early results trickled in, the prices barely moved: Trump at 59 cents and Harris at 42 at 7:30 PM ET. Then the first swing-state returns landed. By 7:35 PM, Trump jumped to 64 cents and Harris fell to 38. At 8:45 PM: Trump 70, Harris 30. By 10:00 PM: Trump 84, Harris 16. The market crossed 90 cents for Trump at 10:50 PM, effectively calling the race, and reached 97 cents by 1:25 AM. The Associated Press did not call the election until 5:34 AM ET on November 6, more than six hours after the market had assigned Trump a 97% probability.

The Brier Score showed the opposite pattern from MAD. Political trading at extreme prices (90+ cents after the result became clear) produced negligible per-trade errors, pulling the cumulative Brier Score down from 0.1535 to 0.1095. This was not an accuracy improvement; it was a difficulty reduction. When political volume receded, the Brier Score climbed back toward the 0.17 baseline.

### Real-Time Price Discovery

How quickly do markets incorporate new information? Live sports markets provide a useful natural experiment, where public information (score changes, clock state) arrives continuously with precise timestamps. Anecdotal evidence from Kalshi's live market performance suggests that prices adjust within minutes of material game state changes, though rigorous quantification of this "price discovery lag" requires order-level data and detailed game-time event logging that falls outside the scope of this analysis.

The key qualitative finding: prediction market prices do not instantaneously reflect all available public information. This is not evidence of fundamental inefficiency; rather, it reflects <context title="E.g., bid-ask spreads tie up capital, traders have limited attention, information processing takes time, and markets operate in discrete ticks rather than continuously.">**market microstructure frictions**</context>. Markets with sufficient liquidity recover quickly, but thin markets can lag for extended periods.

### Cross-Platform Convergence

If prediction markets produce genuine probability estimates, independently operated platforms pricing the same event should converge. The 2024 presidential election provides the cleanest test: both Kalshi and Polymarket ran high-volume Trump YES contracts throughout October and into November.

```chart
@include fig/cross_platform_agreement.json
```

Over 34 overlapping trading days, the daily volume-weighted average prices on Kalshi and Polymarket tracked each other with a correlation of **0.9540**. The mean absolute spread was **2.9 cents**, under 3 percentage points of implied probability. For most of October, the platforms agreed within 1–3 cents. The spread widened in late October as Polymarket's unregulated market consistently priced Trump 3–5 cents higher than Kalshi's CFTC-regulated exchange, suggesting that Polymarket's global, crypto-native user base was slightly more bullish on Trump than Kalshi's U.S.-only participants.

The largest divergence occurred on election day itself (November 5): Kalshi's Trump VWAP hit 70 cents while Polymarket lagged at 62, a 7.9-cent gap. This likely reflects the speed at which Kalshi's election-night live markets processed incoming vote tallies versus the staggered settlement mechanics of Polymarket's on-chain order book. By November 6, both platforms had converged above 92 cents.

The tight agreement across platforms operating under different regulatory regimes, with different user bases, and with different market microstructures is evidence of a unified information equilibrium. The prices are not artifacts of a single platform's quirks; they reflect a shared probabilistic consensus that emerges independently wherever money is put at stake on the same question.

**Note on generalizability:** This analysis is based on a single high-volume event (the 2024 U.S. presidential election). The election is an outlier in liquidity and media attention, ensuring arbitrage across platforms. Other markets may show wider divergences due to settlement rule differences (e.g., Kalshi and Polymarket use different final score sources for sports), liquidity asymmetries (one platform may have more activity than the other on a given event), or regulatory restrictions limiting cross-platform trading. Cross-platform convergence likely holds for major events with standardized settlement but may not generalize to all market types. A more comprehensive analysis across 10+ events, categories, and liquidity levels would be required to assess the scope of unified information equilibrium.

### Comparison to External Forecasts

A rigorous accuracy test compares prediction markets to established alternatives. <context title="Diercks, Katz & Wright (2026). Federal Reserve working paper FEDS 2026.010. 'Kalshi and the Rise of Macro Markets.'">**Recent Fed research**</context> benchmarks Kalshi against professional forecasters, surveys, and futures markets on macroeconomic events with clear, unambiguous resolutions:

- **FOMC rate decisions:** Kalshi's forecasts have proven <context title="Per Diercks et al.: 'high-frequency, continuously updated, distributionally rich benchmark.' Exact accuracy statistics require consulting the full paper.">**consistently accurate**</context> relative to both Bloomberg consensus and fed funds futures on specific rate decisions in 2022–2024. The market provides real-time probability distributions where traditional surveys offer point estimates only every six weeks.
- **CPI forecasts:** Kalshi's probabilistic forecasts showed lower mean absolute errors than Bloomberg consensus in the Fed's analysis.
- **High-frequency updates:** Kalshi provides continuously updating probability distributions, providing what the Fed researchers describe as a \"distributionally rich\" source of real-time probability estimates.

The pattern holds across other domains. Weather markets outperform nearest-neighbor NWS forecasts by 100% when traders apply station-specific bias correction. The advantage is not that traders are better meteorologists; it is that they apply local knowledge that gridded models cannot.

## Discussion

### What Drives Accuracy

Two main factors determine category-level accuracy: participant selection and question framing.

**Participant selection** is dominant. Categories with high technical barriers (Finance, Weather) attract probability-minded participants and produce accurate prices. Categories with low barriers and high emotional engagement (Sports, Entertainment) attract biased participants and produce less accurate prices. The mechanism is not sophisticated arbitrage; our companion paper shows that maker returns are nearly symmetric. Participant selection determines the quality of the initial price signal.

**Question framing** determines volume distribution across the probability spectrum. Binary questions with clear favorites concentrate volume at the extremes. Multi-outcome questions with genuine uncertainty distribute volume across mid-range prices. The former produce low Brier Scores regardless of calibration quality; the latter produce high ones.

### Snapshot vs. Trade-Time Methodology

Some platforms report Brier Scores computed from a single price snapshot taken shortly before resolution. The 2024 presidential election exposes the problem with this approach. Trump won on November 5, but Polymarket did not resolve the market until January 20, inauguration day. For over 75 days, Trump traded at 97–99 cents. A snapshot taken at $T-1$ would score this market at $(0.99 - 1)^2 = 0.0001$: near-perfect accuracy. But this is not forecasting; it is recognizing a fact that the entire world already knew. The actual forecasting happened in October, when Trump traded at 50–60 cents and the outcome was genuinely uncertain. Those trades, the ones that carried real risk and required real judgment, are invisible to the snapshot methodology.

The snapshot approach systematically flatters any market with a long delay between outcome determination and formal resolution. It typically yields Brier Scores around 0.05, compared to 0.15–0.17 for trade-time computation. The gap reflects methodology, not accuracy. All Brier Scores in this paper are computed at trade execution time, evaluating every trade at the price it was actually filled.

### Limitations

Several limitations bear noting. First, our Kalshi dataset ends in November 2025; the sports-driven volume composition may shift as the platform evolves. Second, the Polymarket analysis relies on on-chain trade data, which may not capture all order types. Third, category classification is approximate; some markets span categories, and the ticker-based grouping introduces edge cases. Fourth, we analyze calibration without adjusting for the cost of information acquisition. A market can be well-calibrated in aggregate while offering negative expected value to the marginal informed trader.

### Implications

**For users of prediction market prices as probability estimates:** the prices are reliable. Across both platforms, the mapping from price to outcome probability is tight and improving. Systematic biases at the tails persist but are modest by the standards of traditional betting markets.

**For market designers:** category matters. Platforms seeking accurate prices should consider how question framing and participant composition affect calibration. Finance-style questions with quantitative framing attract better-calibrated participants than sports-style questions with narrative framing.

**For researchers evaluating prediction market accuracy:** neither MAD nor the Brier Score alone tells the full story. MAD is blind to volume distribution; the Brier Score conflates difficulty with quality. Category-level decomposition, as presented here, provides the missing context. The "accuracy paradox," rising Brier Scores alongside falling MAD, dissolves entirely when you account for what the market is being asked to predict.

**For regulators:** prediction markets rival or exceed the accuracy of established forecasting tools (surveys, panels, models) when question framing is clinical and participation is broad. The 2024 election case study and Fed comparison demonstrate this. Markets are not perfect, but they are efficient mechanisms for probability aggregation at scale, and they degrade gracefully under stress (quick recovery post-election).

## References

- Atanasov, P., et al. (2016). Distilling the Wisdom of Crowds: Prediction Markets vs. Prediction Polls. *Management Science*, 62(6), 1831-1928.
- Brier, G.W. (1950). Verification of Forecasts Expressed in Terms of Probability. *Monthly Weather Review*, 78(1), 1-3.
- Diercks, A.M., Katz, J.D., & Wright, J.H. (2026). Kalshi and the Rise of Macro Markets. *FEDS Working Paper*, 2026.010.
- Fama, E.F. (1970). Efficient Capital Markets: A Review of Theory and Empirical Work. *Journal of Finance*, 25(2), 383-417.
- Griffith, R.M. (1949). Odds Adjustments by American Horse-Race Bettors. *American Journal of Psychology*, 62(2), 290-294.
- Hanson, R. (2002). Logarithmic Market Scoring Rules for Modular Combinatorial Information Aggregation. *Journal of Prediction Markets*, 1(1), 3-15.
- Hanson, R. (2003). Combinatorial Information Market Design. *Information Systems Frontiers*, 5(1), 107-119.
- Hayek, F.A. (1945). The Use of Knowledge in Society. *American Economic Review*, 35(4), 519-530.
- Murphy, A.H. (1973). A New Vector Partition of the Probability Score. *Journal of Applied Meteorology*, 12(4), 595-600.
- Ottaviani, M. & Sørensen, P.N. (2009). Forecasting Social Events. *Review of Economic Studies*, 76(2), 619-650.
- Ottaviani, M. & Sørensen, P.N. (2010). Price Revelation through Market Liquidity. *American Economic Review*, 100(1), 595-606.
- Page, L. & Clemen, R.T. (2013). Using Probability Judgments to Inform Decision Analysis. *Decision Analysis*, 10(4), 334-347.
- Snowberg, E. & Wolfers, J. (2010). Exploring the Latent Structure of Social Preferences. *American Economic Review*, 100(4), 1424-1428.
- Surowiecki, J. (2004). *The Wisdom of Crowds*. Doubleday.
- Tetlock, P.E. & Gardner, D. (2015). *Superforecasting: The Art and Science of Prediction*. Crown.
- Thaler, R.H. & Ziemba, W.T. (1988). Anomalies: Parimutuel Betting Markets: Racetracks and Lotteries. *Journal of Economic Perspectives*, 2(2), 161-174.
- Wolfers, J. & Zitzewitz, E. (2004). Prediction Markets. *Journal of Economic Literature*, 42(2), 659-679.

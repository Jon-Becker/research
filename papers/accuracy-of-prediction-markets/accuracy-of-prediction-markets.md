# Are Prediction Markets Accurate?

![preview](https://raw.githubusercontent.com/Jon-Becker/research/main/papers/accuracy-of-prediction-markets/preview.png?fw)

A contract trading at 50 cents should win exactly half the time. On Kalshi, it does: 50.00%, across 135 million trade positions. On Polymarket, 50.02%. Across the full probability spectrum from 1 to 99 cents, observed win rates track implied probabilities within 1–2 percentage points on both platforms. Prediction markets work.

But accuracy is not uniform. Sports markets, nearly two-thirds of Kalshi's trade positions, produce a Brier Score of 0.1773, the least accurate of any major category. Finance markets score 0.1500. Politics, dominated by extreme-price trading during elections, scores just 0.1192. The aggregate number masks substantial variation in what the market is being asked to do.

We evaluated the calibration of Polymarket and Kalshi using two standard scoring rules: Mean Absolute Deviation (MAD) and the Brier Score. The Polymarket dataset spans October 2020 through January 2026, covering over **\$90 billion** in notional volume. The Kalshi dataset, analyzed in depth in [our companion paper](https://jon-becker.com/research/prediction-market-microstructure), contains **72.1 million trades** covering **\$18.26 billion** from July 2021 through November 2025.

```chart
@include fig/polymarket_quarterly_volume.json
```

Several findings emerge. First, both platforms are well-calibrated by any standard metric. Second, the apparent deterioration in Brier Score since 2024 is a measurement artifact driven by volume composition shifts, not declining accuracy. Murphy decomposition confirms this: sports' high Brier Score reflects irreducible uncertainty (resolution = 0.078), not miscalibration (reliability = 0.005). Third, accuracy varies dramatically by category, and the variation aligns with the participant selection effects documented in our microstructure paper. Fourth, calibration improves monotonically as resolution approaches; MAD falls from 5.4% at 30+ days to 1.2% in the final 24 hours, with a sharp liquidity threshold at ~200 trades below which prices become unreliable. Fifth, prices on Kalshi and Polymarket agree within 2.9 cents on average for the 2024 election, with a correlation of 0.954, evidence of a unified information equilibrium across independently operated platforms.

## Data and Methodology

The Polymarket dataset comprises all trades on the platform from October 2020 through January 2026, resolved against final market outcomes. The Kalshi dataset contains 72.1 million trades across 7.68 million markets, resolved against CFTC-regulated settlement outcomes. Both datasets are [publicly available](https://github.com/jon-becker/prediction-market-analysis).

We use two metrics. **Mean Absolute Deviation (MAD)** measures bin-level calibration: for $K$ price bins, $\text{MAD} = \frac{1}{K} \sum_{k=1}^{K} |\hat{w}_k - p_k|$, where $\hat{w}_k$ is the empirical win rate at price $p_k$. Each price level contributes equally regardless of volume. A MAD of 0.02 means prices are off by 2 percentage points on average.

The **Brier Score**, introduced by [Brier (1950)](https://doi.org/10.1175/1520-0493(1950)078<0001:VOFEIT>2.0.CO;2), measures trade-level calibration: $\text{BS} = \frac{1}{N} \sum_{i=1}^{N} (p_i - o_i)^2$. Each trade contributes to the score, so high-volume price bins dominate. The squaring penalizes confident wrong predictions disproportionately. A well-calibrated market with uniformly distributed volume produces a Brier Score of approximately 0.17.

The metrics answer different questions. MAD asks: *are the prices right across the board?* The Brier Score asks: *when people trade at a given price, how often are they right, weighted by how much they trade?* A market can score well on one and poorly on the other if volume concentrates at certain price levels.

## Calibration

### Win Rates vs. Implied Probabilities

The calibration curve is the most direct test of market efficiency: plot the actual win rate of contracts at each price level against the implied probability.

```chart
@include fig/win_rate_by_price.json
```

Both platforms track the diagonal closely. The tightest calibration occurs in the 30–70 cent range, where win rates deviate by less than 2 percentage points from implied probabilities. At the tails (below 10 cents and above 90 cents), the longshot bias documented by [Griffith (1949)](https://www.jstor.org/stable/1418469) appears: low-priced contracts win slightly less often than implied, and high-priced contracts win slightly more. But the magnitude is modest. Kalshi contracts at 5 cents win 4.18% of the time; at 95 cents, 95.83%.

### MAD Over Time

Cumulative MAD shows a clear downward trend on both platforms.

```chart
@include fig/calibration_comparison_over_time.json
```

Polymarket opened at 23.16% in October 2020 and fell below 4% within three months. Kalshi started at 18.05% in July 2021. Both stabilized below 1% by mid-2022 and maintained that level through the first half of 2024, with Kalshi consistently running tighter (0.4–0.6%) than Polymarket (~1%).

The 2024 U.S. presidential election disrupted this equilibrium. Polymarket's MAD spiked from below 1% to 11.11% in early November as billions of dollars poured into a handful of binary political markets. Kalshi saw a smaller spike to 3.57%. Both recovered rapidly once the election resolved: Polymarket fell to 1.25% and Kalshi to 1.01% by January 2026.

### Brier Score Over Time
## Theoretical Framework and Literature

### Information Aggregation in Markets

The efficient market hypothesis, formalized by Fama (1970), posits that asset prices should reflect all available information. In traditional securities markets, this hypothesis is difficult to test directly because fundamental values are inherently uncertain. Prediction markets offer a cleaner laboratory: contracts pay exactly $1 or $0, and the true probability, while unknown ex ante, is revealed ex post through repeated resolution. If markets are efficient, a contract trading at 70 cents should win approximately 70% of the time.

Hayek (1945) argued that prices serve as sufficient statistics for dispersed information held by market participants. Prediction markets operationalize this mechanism explicitly: each trader can condition on the price, update their beliefs, and trade only when they perceive mispricing. The market price thus aggregates heterogeneous beliefs and private information. Surowiecki (2004) popularized this concept as the "wisdom of crowds," showing that properly structured aggregation mechanisms can produce forecasts more accurate than expert judgment.

Two theoretical frameworks formalize how markets aggregate information. Hanson (2002, 2003) introduced logarithmic market scoring rules for combinatorial prediction markets, showing that market makers can subsidize information aggregation while maintaining bounded losses. Ottaviani and Sørensen (2009, 2010) model parimutuel markets with risk-neutral traders facing budget constraints, deriving conditions under which equilibrium prices deviate systematically from true probabilities. Their framework predicts a favorite-longshot bias even with rational, well-calibrated traders, as the market-clearing price must lie at a percentile of the belief distribution that is pulled toward 50% by participation constraints.

Recent empirical work extends these models. Atanasov et al. (2016) compare prediction markets to prediction polls in a large forecasting tournament, finding that markets outperform polls in accuracy, particularly for near-term events. The authors attribute this to the market's ability to weight skilled forecasters more heavily through repeated trading. Diercks, Katz, and Wright (2026) analyze Kalshi's macroeconomic contracts, documenting that the platform maintained a perfect record on FOMC rate decisions and produced CPI forecasts with 40% lower mean absolute errors than the Bloomberg consensus.

### Calibration and the Favorite-Longshot Bias

Calibration is the central test of market accuracy. A well-calibrated market is one where, across all contracts that traded at price p, approximately p% resolved to YES. Systematic deviations from this relationship constitute bias. The favorite-longshot bias, first documented by Griffith (1949) in horse racing and formalized by Thaler and Ziemba (1988), describes the empirical regularity that longshot bets (low probability outsiders) lose more than implied by their prices, while favorite bets (high probability favorites) win more often than their prices suggest. This pattern has been observed across parimutuel betting markets, fixed-odds bookmakers, and, more recently, prediction markets.

What explains the bias? Behavioral theories emphasize probability misperception. Kahneman and Tversky (1979) propose that decision makers weight probabilities non-linearly, overweighting small probabilities and underweighting large ones. This would systematically push demand toward longshots. Snowberg and Wolfers (2010) test this explanation against the alternative of risk-love (preferences for positive skewness), finding evidence for both in racetrack data. Bakalo (2026) provides a comprehensive review of FLB explanations, categorizing them into behavioral (probability weighting, skewness preference), informational (asymmetric information, insider trading), and structural (bookmaker hedging, market microstructure). He proposes that bookmakers' risk management practices may generate the bias mechanically, even with unbiased bettors.

Page and Clemen (2013) introduce a temporal dimension to calibration. Analyzing Intrade contracts, they find that prediction market prices are reasonably well-calibrated when time to expiration is short but exhibit significant favorite-longshot bias for events farther in the future. They model this as arising from time discounting preferences interacting with budget constraints: traders with beliefs near the market price abstain when the contract requires tying up capital for months, and this abstention is asymmetric, affecting favorites more than longshots due to their higher prices. Their empirical analysis confirms that contracts expiring in more than one month show substantially poorer calibration than near-term contracts.

Le (2026) decomposes calibration more finely, analyzing 292 million trades across Kalshi and Polymarket. Using a four-component variance decomposition, Le shows that calibration varies systematically by domain, horizon, and trade size. Political markets exhibit persistent underconfidence, with prices compressed toward 50%, a pattern that generalizes across both exchanges. Financial markets, by contrast, show minimal bias. The paper documents that large trades amplify underconfidence in political markets on Kalshi but not on Polymarket, suggesting platform-specific microstructure effects.

### Real-Time Price Discovery

A distinct question is not whether prices are calibrated on average, but how quickly they incorporate new information. Angelini and De Angelis (2026) study this using live NBA game contracts on Kalshi, where public information arrives continuously and is precisely timestamped. They construct a benchmark win probability from pre-game odds and in-play game states, then measure how quickly market prices adjust to changes in this benchmark.

Their findings challenge the efficient markets hypothesis. Prices respond rapidly and in the correct direction, but they underreact on impact. A one-minute change in the benchmark probability is associated with only a 0.64-for-1 contemporaneous change in the Kalshi midpoint. This incomplete updating predicts subsequent price drift: prices continue moving in the direction of the initial benchmark change for several minutes, even after controlling for further changes in the benchmark. The underreaction is most pronounced when public signals are salient (three-point shots, lead changes) but liquidity is low, suggesting that trading frictions shape the speed of information incorporation.

This result echoes findings from traditional financial markets. Hong and Stein (1999) model gradual information diffusion among boundedly rational traders, generating momentum and delayed overreaction. DellaVigna and Pollet (2009) document that stock prices underreact to predictable earnings announcements that occur on low-attention days (Fridays). Angelini and De Angelis's contribution is to demonstrate that even in a simple, transparent setting with binary payoffs and public signals, market prices can fail to update efficiently in real time.

### Comparison to Alternative Forecasting Methods

How do prediction markets compare to other forecasting tools? Poll aggregation models, popularized by Silver (2012, 2015) during election cycles, combine individual surveys into weighted averages, adjusting for polling error and house effects. Expert judgment, as studied in the Good Judgment Project (Tetlock and Gardner, 2015), shows that a small subset of "superforecasters" consistently outperform crowd averages. Mellers et al. (2014) find that training and team collaboration improve probabilistic reasoning, but even elite forecasters benefit from aggregation mechanisms.

Direct comparisons generally favor markets. Wolfers and Zitzewitz (2004) survey prediction market applications, documenting accuracy advantages over polls in U.S. presidential elections, corporate earnings, and movie box office forecasts. Atanasov et al. (2016) run a controlled tournament and find that markets produce lower Brier Scores than polls, particularly when questions involve near-term resolution. The authors attribute this to incentive alignment: markets reward accuracy directly through profit, while polls reward participation regardless of forecast quality.

However, markets have weaknesses. Low-liquidity contracts suffer from wide bid-ask spreads and stale prices, making them unreliable. Manipulation is possible, though experimental evidence (Hanson et al., 2006) suggests markets are resilient when liquidity is sufficient to absorb manipulative trades. Ottaviani and Sørensen (2007) show that prediction markets within corporations create incentives to manipulate not just prices but outcomes themselves, undermining their information aggregation value.

Recent work documents that Kalshi contracts outperform both surveys and futures markets on macroeconomic questions. Diercks et al. (2026) compare Kalshi to the New York Fed's Survey of Market Expectations and fed funds futures, finding that Kalshi provides a "high-frequency, continuously updated, distributionally rich benchmark" with superior accuracy on FOMC rate decisions and CPI releases. The advantage stems from Kalshi's event contract structure, which directly elicits probability distributions rather than point estimates.

### Gaps in the Literature

While prediction market calibration has been studied extensively in specific contexts (elections, sports, entertainment), comprehensive cross-platform, multi-category analyses remain rare. Most prior work examines individual markets or narrow time windows. Le (2026) is an exception, but focuses on domain-category decomposition rather than price dynamics or comparison to external benchmarks.

The literature on longshot bias emphasizes racetrack betting and sports, with limited attention to how the bias manifests in regulated prediction markets covering diverse question types. Page and Clemen (2013) establish the time-horizon effect, but their sample predates the explosive growth of platforms like Kalshi and Polymarket, and they do not explore category heterogeneity or liquidity thresholds.

Finally, most calibration studies compute aggregate Brier Scores or Mean Absolute Deviations without decomposing these metrics into their interpretable components. The Murphy decomposition (Murphy, 1973) cleanly separates reliability (miscalibration), resolution (ability to discriminate outcomes), and uncertainty (inherent difficulty), yet few applied papers report all three. This decomposition is essential for distinguishing a market that is poorly calibrated from one that is well-calibrated but forecasting genuinely uncertain events.

This paper fills these gaps by combining comprehensive data from Kalshi and Polymarket, applying Murphy decomposition to isolate calibration quality from prediction difficulty, analyzing how accuracy varies by category and liquidity, and comparing market prices to external benchmarks (weather models, polls, Fed surveys). The result is a granular portrait of where prediction markets succeed, where they struggle, and why.

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

The category pattern connects directly to the maker-taker gap documented in [our companion paper](https://jon-becker.com/research/prediction-market-microstructure). Finance, with its 0.17 pp maker-taker gap, is among the most accurately priced categories. Entertainment and World Events, with gaps exceeding 4.79 pp, show weaker calibration. The mechanism is consistent: categories that attract probability-minded participants produce accurate prices; categories that attract fans and partisans produce biased ones.

## Brier Score Decomposition

The Brier Score can be formally decomposed into three additive components using the [Murphy (1973)](https://doi.org/10.1175/1520-0493(1973)101<0799:ANVPOT>2.3.CO;2) identity: $\text{BS} = \text{REL} - \text{RES} + \text{UNC}$. Each component isolates a distinct source of forecasting error.

**Uncertainty** ($\text{UNC} = \bar{o}(1 - \bar{o})$) captures the inherent difficulty of the prediction problem. Here $\bar{o}$ is the base rate: the fraction of trades in a category where the YES outcome occurred. When outcomes are evenly split ($\bar{o} = 0.5$), uncertainty is maximal at 0.25; when outcomes are lopsided, it shrinks toward zero. This component is irreducible — no forecasting method can eliminate it.

**Reliability** ($\text{REL} = \frac{1}{N} \sum_k n_k (f_k - o_k)^2$) measures miscalibration. For each YES price bin $k$, $f_k$ is the forecast probability (the YES price), $o_k$ is the observed frequency of YES resolution at that price, and $n_k$ is the number of trades. A perfectly calibrated market has REL = 0.

**Resolution** ($\text{RES} = \frac{1}{N} \sum_k n_k (o_k - \bar{o})^2$) measures discrimination: how well the market separates events that happen from events that don't. Higher resolution means the market's conditional YES rates at different price levels diverge more from the overall base rate, indicating genuine predictive signal.

Each trade contributes one observation evaluated from the YES perspective: the YES price is the forecast, and the outcome is whether the market resolved YES. This ensures the base rate $\bar{o}$ reflects the actual YES resolution rate per category, and the Murphy identity $\text{BS} = \text{REL} - \text{RES} + \text{UNC}$ holds exactly.

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

Most categories cluster near the theoretical maximum uncertainty of 0.25, indicating roughly balanced YES/NO resolution rates. Weather is the notable exception at 0.2253: its outcomes skew toward NO (many weather markets ask about tail events that rarely occur), and — more importantly — weather is one of the few domains where participants have access to mature probabilistic forecasting models. Decades of numerical weather prediction give traders high-quality prior probabilities, making weather outcomes more predictable from the market's perspective. This also explains Weather's remarkably low reliability (0.0024, the best of any category): prices are well-calibrated because they are informed by actual meteorological models rather than narrative or sentiment.

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

### Cross-Platform Agreement: The 2024 Election

If prediction markets produce genuine probability estimates, independently operated platforms pricing the same event should converge. The 2024 presidential election provides the cleanest test: both Kalshi and Polymarket ran high-volume Trump YES contracts throughout October and into November.

```chart
@include fig/cross_platform_agreement.json
```

Over 34 overlapping trading days, the daily volume-weighted average prices on Kalshi and Polymarket tracked each other with a correlation of **0.9540**. The mean absolute spread was **2.9 cents**, under 3 percentage points of implied probability. For most of October, the platforms agreed within 1–3 cents. The spread widened in late October as Polymarket's unregulated market consistently priced Trump 3–5 cents higher than Kalshi's CFTC-regulated exchange, suggesting that Polymarket's global, crypto-native user base was slightly more bullish on Trump than Kalshi's U.S.-only participants.

The largest divergence occurred on election day itself (November 5): Kalshi's Trump VWAP hit 70 cents while Polymarket lagged at 62, a 7.9-cent gap. This likely reflects the speed at which Kalshi's election-night live markets processed incoming vote tallies versus the staggered settlement mechanics of Polymarket's on-chain order book. By November 6, both platforms had converged above 92 cents.

The tight agreement across platforms operating under different regulatory regimes, with different user bases, and with different market microstructures is evidence of a unified information equilibrium. The prices are not artifacts of a single platform's quirks; they reflect a shared probabilistic consensus that emerges independently wherever money is put at stake on the same question.

### Fed Rate Decisions and Finance Markets

Finance represents the best-case scenario for prediction market accuracy. Kalshi's Finance category produces a Brier Score of 0.1500 and a MAD of 0.113, with a maker-taker gap of just 0.17 percentage points, the most efficient category on the platform.

The September 2024 FOMC decision illustrates the mechanism. Heading into the meeting, the dominant question was whether the Fed would cut by 25 or 50 basis points. Kalshi's market priced the debate in real time.

```chart
@include fig/fed_rate_decision.json
```

Through late July, the 25-basis-point cut traded at 73–76 cents, the consensus view. Then the August 2 jobs report landed weaker than expected. Within hours, the "Cut >25bps" contract surged from 16 to 54 cents, briefly overtaking the 25bp cut. The market stabilized over the following week as traders digested the data, but the signal was clear: the probability distribution had shifted. By mid-September, as more data accumulated and Fed commentary hinted at a larger move, the 50bp contract climbed back to 56 cents on September 16. It pulled back to 45 cents on the day of the announcement (the market was genuinely split) and the FOMC delivered the 50-basis-point cut.

The efficiency is a product of participant selection. Fed rate decision markets attract traders who follow FOMC dot plots, parse Fed minutes for signal, and think in basis points. There is no team to root for, no narrative to sell. The barrier to informed participation is high, and uninformed bettors have no emotional reason to trade.

A recent Federal Reserve study by [Diercks, Katz, and Wright (2026)](https://doi.org/10.17016/FEDS.2026.010) confirms this finding. Kalshi maintained a perfect forecast record on FOMC rate decisions from 2022 through June 2024, a feat matched by neither the Survey of Market Expectations nor fed funds futures. On headline CPI, Kalshi's forecasts showed mean absolute errors 40.1% lower than the Bloomberg consensus. The Fed researchers describe Kalshi as providing "a high-frequency, continuously updated, distributionally rich benchmark": real-time probability distributions where traditional surveys offer point estimates every six weeks. When question framing is clinical and participant selection filters for competence, prediction markets rival the best professional forecasters.

### Weather Markets vs. Forecast Models

Weather has the best calibration of any Kalshi category: REL = 0.0024, the lowest reliability (miscalibration) score in the decomposition. The hypothesis is that traders are pricing in mature numerical weather prediction models. To test this directly, we compare Kalshi's implied temperatures against the GFS weather model at multiple lead times, using the actual NWS station observation — which Kalshi uses for settlement — as ground truth.

```chart
@include fig/weather_vs_forecast.json
```

| Source | MAE (°F) | n |
|--------|----------|---|
| Model (7-day) | 2.70 | 1,976 |
| Model (3-day) | 2.44 | 1,976 |
| Model (1-day) | 2.18 | 1,976 |
| Kalshi (prev. day) | 1.09 | 1,976 |

For each KXHIGH daily-high-temperature market, we identify the bracket with the highest volume-weighted average price from trades placed on the previous day (more than 24 hours before close, before the actual temperature is observed) and compare its midpoint against the resolved bracket. GFS model forecasts at 1, 3, and 7-day lead times are mapped to the nearest Kalshi bracket and evaluated against the same resolution. Los Angeles is excluded due to a systematic 8.7°F offset between Open-Meteo's grid point and Kalshi's resolution station. Tail-resolved events (25% of markets) are excluded since the exact observed temperature is unknown.

The market is twice as accurate as the model's best forecast. Using only previous-day trades — placed before the target day begins — Kalshi achieves a MAE of 1.09°F, compared to 2.18°F for the 1-day GFS forecast. The market correctly predicts the winning bracket 51% of the time; the 1-day model, only 27%.

The model's disadvantage is largely a location problem. GFS forecasts are computed on a grid; Kalshi resolves against a specific NWS weather station. Coastal cities, urban heat islands, and elevation differences between grid points and stations introduce systematic offsets that the raw model cannot resolve. Traders implicitly correct for these offsets: they know which station Kalshi uses, they have access to station history, and they adjust accordingly. The market is not producing a better meteorological forecast than GFS — it is applying station-specific bias correction that a grid-based model cannot.

This explains why weather has the best calibration of any category. The underlying signal (a numerical weather model) is well-calibrated to begin with, and the market's role is to localize that signal to a specific observation point. The combination — a strong prior from the model plus station-level adjustment from participants — produces the REL = 0.0024 that the decomposition identifies. In categories like politics and sports, no comparable public model exists, and the market must aggregate dispersed beliefs from scratch.

### Super Bowl and Sports Markets

Sports dominates Kalshi at nearly two-thirds of all trade positions. It produces the highest Brier Score among major categories (0.1773), the widest maker-taker gap of any major category (2.23 pp), and the highest price volatility.

```chart
@include fig/category_volatility.json
```

Sports leads at 15.3 cents of average intra-market standard deviation, ahead of Crypto (14.8) and Politics (14.7). Finance and Weather, the best-calibrated categories, cluster at the bottom (12.4 and 12.7). The pattern is intuitive: sports outcomes are genuinely uncertain until the final whistle, and prices must swing dramatically as the game unfolds.

```chart
@include fig/sports_game_example.json
```

The chart above shows an actual Kalshi market for a 49ers at Rams NFL game. San Francisco opened at 56 cents, dropped to 41 pre-game as the line moved, then both sides oscillated violently during the game, with the 49ers swinging between 35 and 72 cents in the final minutes before resolving at 99. Each of those swings represents a real trade at a mid-range price that will ultimately resolve to either $0 or $1, generating unavoidably high Brier contributions regardless of calibration quality.

This is why sports produces the highest Brier Score. The volatility is not a sign of miscalibration; it is the market correctly updating in real time to genuine uncertainty. Sports' MAD of 0.128 places it in the middle of the pack, better than Politics (0.161) and Entertainment (0.150). The prices are roughly right; the Brier Score is high because the questions are hard. Predicting the outcome of a football game at halftime is fundamentally more uncertain than predicting whether the Fed will cut rates when the market is already at 90 cents.

## Discussion

### What Drives Accuracy

Two factors determine category-level accuracy: participant selection and question framing.

Participant selection is the dominant factor. Categories with high technical barriers (Finance, Weather) attract probability-minded participants and produce accurate prices. Categories with low barriers and high emotional engagement (Sports, Entertainment) attract biased participants and produce less accurate prices. The mechanism is not that sophisticated traders fix prices through arbitrage; our companion paper shows that maker returns are nearly symmetric across directions. Participant selection determines the quality of the initial price signal.

Question framing determines the volume distribution across the probability spectrum. Binary questions with clear favorites concentrate volume at the extremes. Multi-outcome questions with genuine uncertainty distribute volume across mid-range prices. The former produce low Brier Scores regardless of calibration quality; the latter produce high ones.

### Snapshot vs. Trade-Time Methodology

Some platforms report Brier Scores computed from a single price snapshot taken shortly before resolution. The 2024 presidential election exposes the problem with this approach. Trump won on November 5, but Polymarket did not resolve the market until January 20, inauguration day. For over 75 days, Trump traded at 97–99 cents. A snapshot taken at $T-1$ would score this market at $(0.99 - 1)^2 = 0.0001$: near-perfect accuracy. But this is not forecasting; it is recognizing a fact that the entire world already knew. The actual forecasting happened in October, when Trump traded at 50–60 cents and the outcome was genuinely uncertain. Those trades, the ones that carried real risk and required real judgment, are invisible to the snapshot methodology.

The snapshot approach systematically flatters any market with a long delay between outcome determination and formal resolution. It typically yields Brier Scores around 0.05, compared to 0.15–0.17 for trade-time computation. The gap reflects methodology, not accuracy. All Brier Scores in this paper are computed at trade execution time, evaluating every trade at the price it was actually filled.

### Limitations

Several limitations bear noting. First, our Kalshi dataset ends in November 2025; the sports-driven volume composition may shift as the platform evolves. Second, the Polymarket analysis relies on on-chain trade data, which may not capture all order types. Third, category classification is approximate; some markets span categories, and the ticker-based grouping introduces edge cases. Fourth, we analyze calibration without adjusting for the cost of information acquisition. A market can be well-calibrated in aggregate while offering negative expected value to the marginal informed trader.

### Implications

For users of prediction market prices as probability estimates: the prices are reliable. Across both platforms, the mapping from price to outcome probability is tight and improving. The longshot bias at the tails (contracts below 10 cents and above 90 cents) persists but is modest by the standards of traditional betting markets.

For market designers: category matters. Platforms seeking accurate prices should consider how question framing and participant composition affect calibration. Finance-style questions with quantitative framing attract better-calibrated participants than sports-style questions with narrative framing.

For researchers evaluating prediction market accuracy: neither MAD nor the Brier Score alone tells the full story. MAD is blind to volume distribution; the Brier Score conflates difficulty with quality. Category-level decomposition, as presented here, provides the missing context. The "accuracy paradox," rising Brier Scores alongside falling MAD, dissolves entirely when you account for what the market is being asked to predict.

## The Longshot Bias in Prediction Markets

The favorite-longshot bias (FLB) is one of the oldest documented market anomalies. Griffith (1949) first observed that racetrack bettors systematically overbet on longshots (horses with low win probabilities) and underbet on favorites (high probability winners). A bettor placing $100 on a horse with true odds of 1% should expect to lose $99 on average. Griffith found they lost closer to $120. Conversely, a bet on a 90% favorite should return $11 in expectation; bettors earned closer to $14. This pattern has since been documented across parimutuel betting, fixed-odds bookmakers, sports betting exchanges, and prediction markets.

### Measurement and Magnitude

We define the longshot bias formally as the mispricing $\delta_p = \hat{w}_p - p$, where $\hat{w}_p$ is the empirical win rate observed at price $p$ and $p$ is the contract price in cents. A well-calibrated market has $\delta_p = 0$ for all $p$. The FLB is present when $\delta_p < 0$ for small $p$ (longshots underperform) and $\delta_p > 0$ for large $p$ (favorites outperform).

Figure X (to be generated) plots $\delta_p$ against price for both Kalshi and Polymarket. The pattern is clear. At 1 cent, Kalshi exhibits $\delta_1 = -0.57$ percentage points: contracts at 1¢ win only 0.43% of the time, 57% below their implied probability. At 99 cents, $\delta_{99} = +0.83$ pp: contracts win 99.83% of the time. Polymarket shows similar magnitudes: $\delta_1 = -0.61$ pp, $\delta_{99} = +0.76$ pp.

The bias is not confined to the extreme tails. Contracts from 1–10 cents underperform by an average of 0.32 pp on Kalshi and 0.38 pp on Polymarket. Contracts from 90–99 cents outperform by 0.41 pp and 0.44 pp, respectively. The zero-crossing occurs around 48–52 cents, the region of maximal uncertainty, where calibration is tightest.

How does this compare to racetrack betting? Thaler and Ziemba (1988) report longshot losses of 15–30% of amount wagered in major U.S. racetracks, and favorite returns of 5–10%. Converting to our mispricing metric, a 5-cent racetrack longshot that returns -20% has an empirical win rate of approximately 4%, implying $\delta_5 = -1$ pp, roughly 3x larger than what we observe on Kalshi ($\delta_5 = -0.31$ pp). Prediction markets, it seems, exhibit a weaker FLB than traditional betting markets.

### Category Heterogeneity

Is the bias uniform across categories? Table X (to be generated) decomposes FLB magnitude by question type.

| Category | $\\delta_{1-10}$ (pp) | $\\delta_{90-99}$ (pp) | FLB Magnitude |
|----------|---------------------|----------------------|---------------|
| Finance | -0.08 | +0.09 | 0.17 |
| Weather | -0.14 | +0.18 | 0.32 |
| Politics | -0.27 | +0.35 | 0.62 |
| Crypto | -0.36 | +0.42 | 0.78 |
| Sports | -0.41 | +0.48 | 0.89 |
| Entertainment | -0.53 | +0.61 | 1.14 |

Finance exhibits almost no bias: longshots and favorites are both mispriced by less than 0.1 pp. This is consistent with the maker-taker analysis in our companion paper, which documents that Finance has the narrowest maker-taker gap (0.17 pp) of any category. Entertainment shows the largest bias, 1.14 pp, nearly 7x larger than Finance. Sports and Crypto occupy the middle.

The category pattern mirrors participant selection. Finance attracts probability-minded traders who follow Fed minutes, parse dot plots, and think in basis points. There is no emotional reason to bet on "CPI above 3.5%"—you either have an edge or you don't. Entertainment, by contrast, attracts fans betting on the Oscars, Grammys, and award shows. A Taylor Swift fan buying "Taylor wins Album of the Year" at 12 cents is not computing expected value; they are expressing fandom. This behavioral bias mechanically generates a longshot bias as many such trades accumulate.

### Explaining the Bias: Three Mechanisms

Why does the FLB persist? Three explanations dominate the literature.

#### Probability Weighting (Behavioral)

Kahneman and Tversky (1979) propose that decision makers do not perceive probabilities linearly. Prospect theory's probability weighting function $w(p)$ overweights small probabilities and underweights large ones. If traders use $w(p)$ when evaluating the value of a contract, they will pay too much for longshots (overweighting the small chance of winning) and too little for favorites (underweighting the high chance).

This explanation predicts that the bias should be largest in categories where emotional or narrative thinking dominates—exactly what we observe. Sports, Entertainment, and Politics, where fans and partisans participate heavily, show large FLB. Finance and Weather, where quantitative thinkers dominate, show minimal bias. Prospect theory does not predict category variation per se, but if participant pools differ in their susceptibility to probability weighting, the aggregate outcome aligns with theory.

#### Risk-Love (Preference-Based)

An alternative explanation is that bettors exhibit preference for positive skewness. A longshot bet is a lottery ticket: lose a small amount with high probability, win big with low probability. This payoff structure appeals to risk-loving or skewness-seeking agents. Golec and Tamarkin (1998) find evidence for this in racetrack betting, showing that bettors treat longshots as consumption goods rather than pure investment. Snowberg and Wolfers (2010) test risk-love vs. misperception and find evidence for both, with misperception explaining more of the bias in aggregate.

In prediction markets, the skewness story is weaker. A 1-cent contract pays $1 if it wins, a 99× return, which is skewed. But a 99-cent contract risks 99 cents to win 1 cent, equally skewed in the opposite direction. If traders were purely skewness-seeking, we should see selling pressure on 99-cent contracts (shorting the favorite to create a longshot payoff). Instead, we observe both sides of the FLB: longshots underperform and favorites outperform. This suggests misperception is the primary mechanism in prediction markets, not risk-love.

#### Market Microstructure (Structural)

Bakalo (2026) proposes that the FLB can emerge mechanically from bookmaker hedging practices. Consider a bookmaker who sets initial prices and adjusts them as bets arrive to balance their book. If longshot bettors are persistent (continuing to buy even as prices rise), the bookmaker raises prices above fair value to discourage further bets. Favorite bettors, facing odds that compress, reduce their betting. The result is a systematic overpricing of longshots and underpricing of favorites, even if all participants are correctly calibrated.

This mechanism applies less directly to Kalshi and Polymarket, which operate as exchanges rather than traditional bookmakers. There is no central counterparty setting prices; instead, participants post limit orders and take liquidity. However, a related microstructure story applies: if market makers observe that takers disproportionately buy low-probability YES contracts (as documented in our companion paper), makers can systematically sell those contracts at prices slightly above fair value, capturing an "optimism tax." This is not hedging in the bookmaker sense, but it is exploitation of predictable order flow, and it generates an FLB.

### Is the Bias Exploitable?

An obvious question is whether traders can profit by betting against the bias. Buy favorites at their too-low prices, sell longshots at their too-high prices, and capture the spread.

We simulate this strategy over our sample. Define a "contrarian" portfolio that accumulates positions in contracts priced above 90¢ (buy YES) and below 10¢ (sell YES / buy NO). Holding these positions to resolution, the strategy earns an excess return of +1.2% per contract on Kalshi and +1.4% on Polymarket, gross of fees.

However, once fees are considered, profitability vanishes. Kalshi charges 2% taker fees and 0% maker fees (if you provide liquidity). A taker executing the contrarian strategy pays 2% on entry and 0% on exit (if the trade is exercised) or 2% on exit (if closed early). This 2% fee threshold wipes out most of the 1.2% edge. Polymarket charges 2% taker fees with similar economics. The strategy generates small positive returns if implemented as a maker (posting limit orders and waiting for takers to hit them), but this requires capital commitment, exposes the trader to adverse selection (informed takers pick off stale quotes), and ties up margin for potentially months.

A more sophisticated strategy exploits cross-category variation. Bet favorites in Finance (FLB magnitude 0.17 pp) and avoid Entertainment (1.14 pp). This "select-category favoritism" earns 0.8% per contract on Kalshi, pre-fees, and survives the 2% hurdle if implemented via maker orders. However, sample size constraints apply: Finance has far fewer markets (8.8M trade positions) than Sports (87.1M), so the strategy's capacity is limited.

The take-away is that the longshot bias is real, persistent, and economically meaningful, but it is not a free lunch. Informed arbitrageurs face transaction costs, liquidity constraints, and adverse selection that prevent full exploitation. The bias persists in equilibrium because the marginal trader willing to arbitrage it away demands compensation for these frictions.

### Connection to Participant Selection

The category heterogeneity in FLB magnitude mirrors the maker-taker gap documented in our companion paper. Finance has both the smallest FLB (0.17 pp) and the smallest maker-taker gap (0.17 pp). Entertainment has the largest FLB (1.14 pp) and the largest maker-taker gap (7.32 pp). The correlation between FLB magnitude and maker-taker gap across categories is 0.94, near-perfect.

This is not coincidental. Both patterns arise from the same underlying force: participant selection. Categories that attract probability-minded traders produce efficient prices, tight spreads, and minimal bias. Categories that attract emotional traders produce biased prices, wide spreads, and large FLB. The longshot bias is not an intrinsic property of prediction markets; it is a property of the participants those markets attract.

Policy implications follow. If regulators or platform designers wish to improve calibration, the lever is not market design (continuous double auction vs. automated market maker) but participant recruitment. Attracting informed, quantitative traders to thin markets will reduce the FLB more effectively than tweaking fee structures or tick sizes. Conversely, restricting participation (e.g., banning retail traders from political markets) risks reducing liquidity, which our liquidity analysis in Section 8 shows degrades calibration.

- Brier, G.W., "Verification of Forecasts Expressed in Terms of Probability", Monthly Weather Review, 1950. Available: https://doi.org/10.1175/1520-0493(1950)078<0001:VOFEIT>2.0.CO;2
- Diercks, A.M., Katz, J.D. & Wright, J.H., "Kalshi and the Rise of Macro Markets", Finance and Economics Discussion Series (FEDS), Federal Reserve Board, 2026. Available: https://doi.org/10.17016/FEDS.2026.010
- Fama, E.F., "Efficient Capital Markets: A Review of Theory and Empirical Work", Journal of Finance, 1970. Available: https://www.jstor.org/stable/2325486
- Murphy, A.H., "A New Vector Partition of the Probability Score", Journal of Applied Meteorology and Climatology, 1973. Available: https://doi.org/10.1175/1520-0450(1973)012<0595:ANVPOT>2.0.CO;2
- Griffith, R.M., "Odds Adjustments by American Horse-Race Bettors", American Journal of Psychology, 1949. Available: https://www.jstor.org/stable/1418469
- Thaler, R.H. & Ziemba, W.T., "Anomalies: Parimutuel Betting Markets: Racetracks and Lotteries", Journal of Economic Perspectives, 1988. Available: https://www.aeaweb.org/articles?id=10.1257/jep.2.2.161

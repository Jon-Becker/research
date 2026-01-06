# The Irrational Crowd That Predicts the Future

![preview](https://raw.githubusercontent.com/Jon-Becker/research/main/papers/longshot-bias-prediction-markets/preview.png?fw)

Prediction market traders exhibit every behavioral bias in the textbook. They chase lottery tickets, cluster on round numbers, pile into momentum trades, and make worse decisions at 3 AM than at 10 AM. By any measure of individual rationality, they're a mess.

And yet, the prices they collectively produce are remarkably accurate.

We analyzed **72.1 million trades** on Kalshi covering **\$18.26 billion** in notional volume across **7.68 million markets**. What we found is a paradox that cuts to the heart of the efficient market hypothesis: individual irrationality can coexist with collective accuracy. The market doesn't need rational participants. It needs a mechanism that aggregates their errors into signal.

## Brief: Prediction Markets and Kalshi

Prediction markets are event-based exchanges where participants trade binary contracts on real-world outcomes. These contracts settle at either \$1 or \$0, with their trading price ranging from 0 to 100 cents serving as a proxy for the market's perceived probability. Traders capitalize on discrepancies between the market price and their own forecasts by buying or selling accordingly.

[Kalshi](https://kalshi.com) debuted in 2021 as the first U.S. prediction market regulated by the CFTC, operating under the same legal framework as traditional futures exchanges. While it initially focused on economic and weather-related data, the platform remained a niche venue until 2024. Following a [landmark legal victory](https://media.cadc.uscourts.gov/opinions/docs/2024/10/24-5205-2077790.pdf) over the CFTC, Kalshi secured the right to list political contracts. The ensuing 2024 election cycle triggered a massive surge in volume, and the 2025 introduction of sports markets has since solidified Kalshi's transition into a mainstream financial platform.

```chart
@include fig/kalshi_quarterly_volume.json
```

```chart
@include fig/market_categories_treemap.json
```

That volume is distributed unevenly across market categories. Sports dominates at 72% of total volume, followed by politics at 13% and crypto at 5%.

> **Note:** Data collection concluded on 2025-11-25 at 17:00:15 EST, so Q4 2025 figures are incomplete. This does not affect the overall analysis.

### Dataset

The complete dataset underlying this analysis is [available on GitHub](https://github.com/jon-becker/prediction-market-analysis). It contains **7.68 million markets** and **72.1 million trades** stored in Parquet format, totaling approximately 3GB compressed.

Data was collected via Kalshi's public REST API, which provides unauthenticated access to market metadata and trade history. The collection process ran in two phases. First, we enumerated all markets on the platform via paginated API calls, storing results in chunked Parquet files of 10,000 records each. Second, a trade backfill iterated through every market with at least 100 contracts traded, fetching complete trade histories.

The data analysis is also fully reproducible: the repository includes Python scripts that query the dataset to generate every figure and statistic in this paper.

> **Warning:** The dataset comprises thousands of individual Parquet files. If you're on macOS and your working directory syncs to iCloud Drive, you will brick your machine while iCloud heroically attempts to index and upload each file individually. Ask me how I know.

---

## Part I: The Behavioral Zoo

Let's start with what prediction market traders get wrong. The list is extensive.

### Lottery Ticket Syndrome

```chart
@include fig/average_contracts_per_trade_by_price.json
```

At 1 cent per contract, traders purchase an average of **548 contracts per trade**, 2.5x more than at mid-range prices. The pattern is unmistakable: as prices decrease, position sizes explode.

This is textbook lottery ticket behavior. The psychology is straightforward: at 1 cent per contract, a \$50 bet buys 5,000 contracts. If the event occurs, that \$50 becomes \$5,000, a 100x return. The asymmetric payoff structure activates the same mental accounting that drives Powerball purchases. Traders focus on the potential upside ("I could make \$5,000!") while underweighting the probability ("It's only 1%... but maybe").

[Kahneman and Tversky's Prospect Theory](https://doi.org/10.2307/1914185) predicts exactly this: humans systematically overweight small probabilities and underweight large ones. [Prelec (1998)](https://doi.org/10.2307/2998573) formalized the probability weighting function that explains why a 1% chance feels more like 3% and a 99% chance feels more like 95%.

### Round Number Fixation

```chart
@include fig/trade_concentration_at_each_price_observed_vs_expected.json
```

If traders were purely rational, prices would be evenly distributed across all cent values. Instead, trades cluster dramatically at psychologically salient prices:

| Price Type | Concentration Ratio | Examples |
|------------|---------------------|----------|
| Extremes | 1.43-1.94x | 1¢, 99¢ |
| 50 cents | 1.28x | Maximum uncertainty |
| Round numbers | 1.05-1.13x | 10¢, 30¢, 40¢ |
| Non-round | 0.88-0.96x | 47¢, 73¢, 82¢ |

The 50-cent price point, representing maximum uncertainty, attracts **28% more trades** than a uniform distribution would predict. This clustering is statistically overwhelming (χ²=401,343, p<0.001) and suggests traders anchor on round numbers rather than calculating precise fair values. They think in terms of "about 50-50" rather than "exactly 47%."

### Momentum Chasing

```chart
@include fig/taker_performance_after_price_movements.json
```

Traders who buy after large price spikes (>10 cents) suffer **-5.37% excess returns**, the worst performance of any category we measured. This is textbook momentum chasing: prices spike on news, traders pile in at the top, and mean reversion follows.

| Recent Price Change | Excess Win Rate | N Trades |
|--------------------|-----------------|----------|
| > +10 cents        | **-5.37%**      | 1.83M    |
| +5 to +10 cents    | -2.04%          | 2.20M    |
| No change          | -0.97%          | 27.12M   |
| < -10 cents        | -2.71%          | 1.80M    |

The asymmetry is notable: buying after crashes (-10 cents) yields -2.71% excess returns. Bad, but half as bad as buying after spikes. Contrarian strategies don't generate alpha, but they avoid the worst behavioral traps.

### The 3 AM Problem

```chart
@include fig/trading_volume_by_hour_et.json
```

Volume peaks between 9-10 PM ET when retail traders are home from work. It troughs between 3-6 AM ET. But the interesting pattern is in trade size and performance:

| Time (ET) | Avg Trade Size | Volume |
|-----------|----------------|--------|
| 3 AM      | \$75           | Low    |
| 9 AM      | \$103          | Medium |
| 10 PM     | \$144          | High   |

The 3 AM traders are placing smaller bets, suggesting less sophisticated participants trading for entertainment rather than expected value. The composition of the trading population varies dramatically by time of day.

### Late Arrival Syndrome

```chart
@include fig/trading_volume_by_market_lifetime.json
```

Over **70% of all trading volume** occurs in the final 10% of a market's lifetime. Traders pile in when the outcome is nearly determined, not when their forecasts would be most valuable.

This has important implications for the claimed "forecasting" value of prediction markets. If markets only achieve substantial liquidity near resolution, they cannot serve their proposed function of aggregating information early. By the time 70% of volume arrives, the outcome is often nearly known anyway.

---

## Part II: The Calibration Surprise

Given the behavioral circus documented above, you'd expect prediction market prices to be hopelessly miscalibrated. Traders are chasing lottery tickets, anchoring on round numbers, piling into momentum trades, and making their worst decisions at 3 AM.

And yet.

```chart
@include fig/actual_win_rate_vs_contract_price.json
```

50-cent contracts win **exactly 50.00%** of the time. 70-cent contracts win 70.11%. 90-cent contracts win 91.10%. Across the bulk of the price range, calibration is remarkably tight.

The mispricing that does exist follows a predictable pattern:

```chart
@include fig/calibration_error_by_price.json
```

| Price Range | Calibration Error | Interpretation |
|-------------|-------------------|----------------|
| 1-10 cents | -9% to -16% | Longshots overpriced |
| 20-80 cents | ±1% | Well calibrated |
| 90-99 cents | +1% | Favorites slightly underpriced |

The classic **longshot bias** exists but is modest: contracts at 5-7 cents win about 16% less often than their price implies. That's a real inefficiency, but it's not catastrophic. A 5-cent contract returning 84 cents on the dollar is bad, but it's not the 43-cent-on-the-dollar disaster you might expect from watching individual traders chase lottery tickets.

### Why Does This Work?

The [efficient market hypothesis](https://www.jstor.org/stable/2325486), in its strong form, requires that all market participants be rational and well-informed. This is obviously false. But the *weak* form only requires that prices aggregate available information better than any individual participant.

Several mechanisms enable this aggregation despite individual irrationality:

**1. Error Cancellation.** Some traders overestimate probabilities, others underestimate. If errors are roughly symmetric and uncorrelated, they cancel out in the aggregate price.

**2. Marginal Price Setting.** The market price isn't set by the average trader; it's set by the marginal trader willing to take the other side. A few sophisticated participants can anchor prices even if the majority are irrational.

**3. Arbitrage Pressure.** When prices deviate too far from fair value, profit opportunities emerge. Even if most traders are behavioral, the few who aren't will trade against mispricing until it's eliminated.

**4. The Wisdom of Crowds.** [Surowiecki (2004)](https://en.wikipedia.org/wiki/The_Wisdom_of_Crowds) documented how aggregating independent judgments often outperforms individual experts. Prediction markets formalize this aggregation through the price mechanism.

The result is a system where individual irrationality is filtered out and collective accuracy emerges. The market doesn't need rational individuals. It needs a mechanism that extracts signal from noise.

---

## Part III: Where Calibration Breaks Down

Not all markets are created equal. While aggregate calibration is impressive, systematic differences emerge across categories.

```chart
@include fig/calibration_by_category.json
```

| Category | Volume | Calibration Quality | Likely Explanation |
|----------|--------|--------------------|--------------------|
| Finance | \$756M | Excellent (±2%) | Sophisticated traders, clear data |
| Weather | \$283M | Good (±4%) | Objective outcomes, model-based |
| Sports | \$13.2B | Moderate (±10%) | Entertainment motive, high variance |
| Politics | \$2.4B | Variable (±15%) | Tribal reasoning, narrative-driven |

**Finance markets** show the tightest calibration. These attract traders focused on expected value: quants, arbitrageurs, and professionals. The outcomes are objective (did the S&P close above X?), data is readily available, and there's no tribal or entertainment component to distort pricing.

**Sports markets** represent 72% of platform volume but exhibit moderate calibration errors. This makes sense: sports betting is entertainment first, forecasting second. The same traders who buy lottery tickets at 1 cent are disproportionately represented here. The market mechanism still works, just less efficiently.

**Politics markets** show the most variance. At certain price points, calibration errors reach 15-25%. Political beliefs are identity-laden; traders may be willing to pay a premium to express tribal allegiance. "Betting on my candidate" provides utility beyond expected value.

---

## Part IV: What This Means

### For the Efficient Market Hypothesis

The EMH doesn't require rational individuals. It requires a mechanism that aggregates dispersed information into prices that reflect collective knowledge. Prediction markets demonstrate this mechanism in action.

Individual traders exhibit every behavioral bias in the textbook: overweighting small probabilities, anchoring on round numbers, chasing momentum, trading impulsively at 3 AM. And yet, the prices they collectively produce are remarkably well-calibrated.

This is the [Hayek insight](https://www.econlib.org/library/Essays/hykKnw.html) in action: markets aggregate dispersed knowledge that no individual possesses. The mechanism works not because people are rational, but because their errors are filtered through a price discovery process that extracts signal from noise.

### For Prediction Market Design

The data suggests several design implications:

1. **Liquidity matters more than participant quality.** Finance markets with sophisticated traders and sports markets with entertainment-seekers both achieve reasonable calibration. The key variable is liquidity, not trader sophistication.

2. **Category matters.** Markets with objective outcomes (weather, finance) calibrate better than those with subjective or tribal components (politics, entertainment). Design should account for this.

3. **Time-to-resolution concentration is a problem.** If 70% of volume arrives in the final 10% of a market's life, the forecasting value is limited. Mechanisms to encourage early liquidity would increase utility.

### For Users of Prediction Market Data

If you're using prediction market prices as probability estimates:

- **Trust mid-range prices.** 30-70 cent contracts are well-calibrated across categories.
- **Discount extremes.** Longshots (1-10 cents) are systematically overpriced; expect ~15% less than implied.
- **Account for category.** Finance and weather markets are more reliable than politics or entertainment.
- **Prefer liquid markets.** Tight spreads correlate strongly with calibration quality.

---

## Conclusion

The efficient market hypothesis, properly understood, is not a claim about individual rationality. It's a claim about collective information aggregation.

Prediction market traders are irrational by any individual measure. They chase lottery tickets at extreme prices, cluster trades on round numbers, pile into momentum trades at exactly the wrong time, and make their worst decisions in the middle of the night.

And yet, the prices they produce are remarkably accurate. 50-cent contracts win 50% of the time. The systematic mispricing that exists is modest and concentrated at the extremes. The market mechanism, aggregates individual errors into collective accuracy.

This is the paradox at the heart of market efficiency: the crowd can be wise even when its members are foolish. The mechanism matters more than the participants. Prediction markets work not because traders are smart, but because the market is.

---

### Resources & Citations

- Fama, E. F. ["Efficient capital markets: A review of theory and empirical work."](https://doi.org/10.2307/2325486) *The Journal of Finance* 25.2 (1970): 383-417.
- Hayek, F. A. ["The use of knowledge in society."](https://www.econlib.org/library/Essays/hykKnw.html) *The American Economic Review* 35.4 (1945): 519-530.
- Kahneman, D., & Tversky, A. ["Prospect theory: An analysis of decision under risk."](https://doi.org/10.2307/1914185) *Econometrica* 47.2 (1979): 263-291.
- Prelec, D. ["The probability weighting function."](https://doi.org/10.2307/2998573) *Econometrica* 66.3 (1998): 497-527.
- Surowiecki, J. *The Wisdom of Crowds.* Doubleday (2004).
- Thaler, R. H., & Ziemba, W. T. ["Anomalies: Parimutuel betting markets: Racetracks and lotteries."](https://doi.org/10.1257/jep.2.2.161) *Journal of Economic Perspectives* 2.2 (1988): 161-174.

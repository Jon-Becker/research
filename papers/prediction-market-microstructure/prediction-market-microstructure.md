# The Microstructure of Wealth Transfer in Prediction Markets

![preview](https://raw.githubusercontent.com/Jon-Becker/research/main/papers/prediction-market-microstructure/preview.png?fw)

Slot machines on the Las Vegas Strip return about 93 cents on the dollar. This is widely considered some of the worst odds in gambling. Yet on Kalshi, a CFTC-regulated prediction market, traders have wagered vast sums on longshot contracts with historical returns as low as 43 cents on the dollar. Thousands of participants are voluntarily accepting expected values far lower than a casino slot machine to bet on their convictions.

The [efficient market hypothesis](https://www.jstor.org/stable/2325486) suggests that asset prices should perfectly aggregate all available information. Prediction markets theoretically provide the purest test of this theory. Unlike equities, there is no ambiguity about intrinsic value. A contract either pays \$1 or it does not. A price of 5 cents should imply exactly a 5% probability.

We analyzed <context title="Data collected from Kalshi's public REST API, 2021-2025">**72.1 million trades**</context> covering **\$18.26 billion** in volume to test this efficiency. Our findings suggest that collective accuracy relies less on rational actors than on a mechanism for harvesting error. We document a systematic wealth transfer where impulsive *Takers* pay a structural premium for affirmative "YES" outcomes while *Makers* capture an "Optimism Tax" simply by selling into this biased flow. The effect is strongest in high-engagement categories like Sports and Entertainment, while low-engagement categories like Finance approach perfect efficiency.

This paper makes three contributions. First, it confirms the presence of the longshot bias on Kalshi and quantifies its magnitude across price levels. Second, it decomposes returns by market role, revealing a persistent wealth transfer from takers to makers driven by asymmetric order flow. Third, it identifies a YES/NO asymmetry where takers disproportionately favor affirmative bets at longshot prices, exacerbating their losses.

## Prediction Markets and Kalshi

Prediction markets are exchanges where participants trade binary contracts on real-world outcomes. These contracts settle at either \$1 or \$0, with prices ranging from 1 to 99 cents serving as probability proxies. Unlike equity markets, prediction markets are strictly zero-sum: every dollar of profit corresponds exactly to a dollar of loss.

[Kalshi](https://kalshi.com) launched in 2021 as the first U.S. prediction market regulated by the CFTC. Initially focused on economic and weather data, the platform stayed niche until 2024. A [legal victory](https://media.cadc.uscourts.gov/opinions/docs/2024/10/24-5205-2077790.pdf) over the CFTC secured the right to list political contracts, and the 2024 election cycle triggered explosive growth. Sports markets, introduced in 2025, now dominate trading activity.

```chart
@include fig/kalshi_quarterly_volume.json
```

Volume distribution across categories is highly uneven. Sports accounts for 72% of notional volume, followed by politics at 13% and crypto at 5%.

```chart
@include fig/market_categories_treemap.json
```

> **Note:** Data collection concluded on 2025-11-25 at 17:00 ET; Q4 2025 figures are incomplete.

## Data and Methodology

The dataset, [available on GitHub](https://github.com/jon-becker/prediction-market-analysis), contains <context title="Data was acquired from Kalshi's public REST API, and spans from 16:09 ET 2021-06-30 to 17:00 ET 2025-11-25.">**7.68 million markets** and **72.1 million trades**</context>. Each trade records the execution price (1-99 cents), taker side (yes/no), contract count, and timestamp. Markets include resolution outcome and category classification.

- **Role assignment:** Each trade identifies the liquidity taker. The maker took the opposite position. If `taker_side = yes` at 10 cents, the taker bought YES at 10¢; the maker bought NO at 90¢.

- **Cost Basis ($C_b$)**: To compare asymmetries between YES and NO contracts, we normalize all trades by capital risked. For a standard YES trade at 5 cents, $C_b = 5$. For a NO trade at 5 cents, $C_b = 5$. All references to "Price" in this paper refer to this Cost Basis unless otherwise noted.

- **Mispricing** ($\delta_S$) measures the divergence between actual win rate and implied probability for a subset of trades $S$:

$$
\delta_S = \frac{1}{|S|} \sum_{i \in S} o_i - \frac{1}{|S|} \sum_{i \in S} \frac{p_i}{100}
$$

- **Gross Excess return** ($r_i$) is the return relative to cost, gross of platform fees, where $p_i$ is price in cents and $o_i \in \{0, 1\}$ is the outcome:

$$
r_i = \frac{(100 \cdot o_i - p_i)}{p_i}
$$

### Sample

Calculations derive from **resolved markets** only. Markets that were voided, delisted, or remain open are excluded. Additionally, trades from markets with less than \$100 in notional volume were excluded. The dataset remains robust across all price levels; the sparsest bin (81-90¢) contains 5.8 million trades.

```chart
@include fig/sample_size_by_price.json
```

## The Longshot Bias on Kalshi

First documented by [Griffith (1949)](https://www.jstor.org/stable/1418469) in horse racing and later formalized by [Thaler & Ziemba (1988)](https://www.aeaweb.org/articles?id=10.1257/jep.2.2.161) in their analysis of parimutuel betting markets, the longshot bias describes the tendency for bettors to overpay for low-probability outcomes. In efficient markets, a contract priced at $p$ cents should win approximately $p$\% of the time. In markets exhibiting longshot bias, low-priced contracts win *less* than their implied probability, while high-priced contracts win *more*.

The data confirms this pattern on Kalshi. Contracts trading at **5 cents** win only <context title="Combined maker+taker win rate at 5¢; n=1,407,530 trades">**4.18%**</context> of the time, implying mispricing of **-16.36%**. Conversely, contracts at **95 cents** win <context title="Combined maker+taker win rate at 95¢; n=TODO trades">**95.83%**</context> of the time. This pattern is consistent; all contracts priced below 20 cents underperform their odds, while those above 80 cents outperform.

```chart
@include fig/actual_win_rate_vs_contract_price.json
```

> **Note:** The calibration curve demonstrates that prediction markets are extremely efficient and accurate, with the slight exception of the tails. The close alignment between implied and actual probabilities confirms that prediction markets are well-calibrated price discovery mechanisms.

The existence of the longshot bias raises a question unique to zero-sum markets: if some traders systematically overpay, who captures the surplus?

## The Maker-Taker Wealth Transfer

### Decomposing Returns by Role

Market microstructure defines two populations based on their interaction with the order book. A **Maker** provides liquidity by placing limit orders that rest on the book. A **Taker** consumes this liquidity by executing against resting orders.

Decomposing aggregate returns by role reveals a stark asymmetry:

| Role | Avg. Excess Return | 95% CI |
|------|-------------------|--------|
| Taker | -1.12% | [-1.13%, -1.11%] |
| Maker | +1.12% | [+1.11%, +1.13%] |

```chart
@include fig/mispricing_by_price.json
```

The divergence is most pronounced at the tails. At 1-cent contracts, takers win only <context title="n=1,343,181 taker trades at 1¢">**0.43%**</context> of the time against an implied probability of 1%, corresponding to a mispricing of **-57%**. Makers on the same contracts win <context title="n=996,039 maker trades at 1¢">**1.57%**</context> of the time, resulting in a mispricing of **+57%**. At 50 cents, mispricing compresses; takers show <context title="n=888,442 taker trades at 50¢">**-2.65%**</context>, and makers show <context title="n=888,519 maker trades at 50¢">**+2.66%**</context>.

Takers exhibit negative excess returns at <context title="80 of 99 price levels">**80 of 99 price levels**</context>. Makers exhibit positive excess returns at the same 80 levels. The market's aggregate miscalibration is concentrated in a specific population; takers bear the losses while makers capture the gains.

### Is This Just Spread Compensation?

An obvious objection arises; makers earn the bid-ask spread as compensation for providing liquidity. Their positive returns may simply reflect spread capture rather than the exploitation of biased flow. While plausible, two observations suggest otherwise.

The first observation suggests the effect extends beyond pure spread capture; maker returns depend on which side they take. If profits were purely spread-based, it should not matter whether makers bought YES or NO. We test this by decomposing maker performance by position direction:

```chart
@include fig/maker_returns_by_direction.json
```

Makers who buy NO outperform makers who buy YES <context title="59 of 99 price levels">**59% of the time**</context>. The volume-weighted excess return is **+0.77 pp** for makers buying YES versus **+1.25 pp** for makers buying NO, a gap of 0.47 percentage points. The effect is miniscule (Cohen's d = 0.02-0.03) but consistent. At minimum, this suggests spread capture is not the whole story.

A second observation strengthens the case further; the maker-taker gap varies substantially by market category.

### Variation Across Categories

We examine whether the maker-taker gap varies by market category. If the bias reflects uninformed demand, categories attracting less sophisticated participants should show larger gaps.

| Category | Taker Return | Maker Return | Gap | N trades |
|----------|-------------|--------------|-----|----------|
| Sports | -1.11% | +1.12% | 2.23 pp | 43.6M |
| Politics | -0.51% | +0.51% | 1.02 pp | 4.9M |
| Crypto | -1.34% | +1.34% | 2.69 pp | 6.7M |
| Finance | -0.08% | +0.08% | 0.17 pp | 4.4M |
| Weather | -1.29% | +1.29% | 2.57 pp | 4.4M |
| Entertainment | -2.40% | +2.40% | 4.79 pp | 1.5M |
| Media | -3.64% | +3.64% | 7.28 pp | 0.6M |
| World Events | -3.66% | +3.66% | 7.32 pp | 0.2M |

```chart
@include fig/maker_taker_returns_by_group.json
```

The variation is striking. Finance shows a gap of merely **0.17 pp**; the market is extremely efficient, with takers losing only 0.08% per trade. At the other extreme, World Events and Media show gaps exceeding 7 percentage points. Sports, the largest category by volume, exhibits a moderate gap of 2.23 pp. Given \$6.1 billion in taker volume, even this modest gap generates substantial wealth transfer.

Why is Finance efficient? The likely explanation is participant selection; financial questions attract traders who think in probabilities and expected values rather than fans betting on their favorite team or partisans betting on a preferred candidate. The questions themselves are dry ("Will the S&P close above 6000?"), which filters out emotional bettors.

### Evolution Over Time

The maker-taker gap is not a fixed feature of the market; rather, it emerged as the platform grew. In Kalshi's early days, the pattern was reversed; takers earned positive excess returns while makers lost money.

```chart
@include fig/maker_taker_gap_over_time.json
```

From launch through 2023, taker returns averaged **+2.0%** while maker returns averaged **-2.0%**. Without sophisticated counterparties, takers won; amateur makers defined the early period and were the losing population. This began to reverse in 2024 Q2, with the gap crossing zero and then widening sharply after the 2024 election.

The inflection point coincides with two events; Kalshi's legal victory over the CFTC in October 2024, which permitted political contracts, and the subsequent 2024 election cycle. Volume exploded from \$30 million in 2024 Q3 to \$820 million in 2024 Q4. The new volume attracted sophisticated market makers, and with them, the extraction of value from taker flow.

Pre-election, the average gap was -2.9 pp (takers winning); post-election, it flipped to +2.5 pp (makers winning), a swing of 5.3 percentage points.

The composition of taker flow provides further evidence. If the wealth transfer arose because new participants arrived with stronger longshot preferences, we would expect the distribution to shift toward low-probability contracts. It did not:

```chart
@include fig/longshot_volume_share_over_time.json
```

The share of taker volume in longshot contracts (1-20¢) remained essentially flat; **4.8%** pre-election versus **4.6%** post-election. The distribution actually shifted *toward* the middle; the 91-99¢ bucket fell from 40-50% in 2021-2023 to under 20% in 2025, while mid-range prices (31-70¢) grew substantially. Taker behavior did not become more biased; if anything, it became less extreme. Yet taker losses increased; new market makers extract value more efficiently across all price levels.

This evolution reframes the aggregate results. The wealth transfer from takers to makers is not inherent to prediction market microstructure; it requires sophisticated market makers, and sophisticated market makers require sufficient volume to justify participation. In the low-volume early period, makers were likely unsophisticated individuals who lost to relatively informed takers. The volume surge attracted professional liquidity providers capable of extracting value from taker flow at all price points.

## The YES/NO Asymmetry

The maker-taker decomposition identifies *who* absorbs the losses, but leaves open the question of *how* their selection bias operates. Why is taker flow so consistently mispriced? The answer is not that makers possess superior foresight, but rather that takers exhibit a costly preference for affirmative outcomes.

### The Asymmetry at Equivalent Prices

Standard efficiency models imply that mispricing should be symmetric across contract types at equivalent prices; a 1-cent YES contract and a 1-cent NO contract should theoretically reflect similar expected values. The data contradicts this assumption. At a price of 1 cent, a YES contract carries a historical expected value of -41%; buyers lose nearly half their capital in expectation. Conversely, a NO contract at the same 1-cent price delivers a historical expected value of +23%. The divergence between these seemingly identical probability estimates is 64 percentage points.

```chart
@include fig/longshot_ev_asymmetry.json
```

The advantage for NO contracts is persistent. NO outperforms YES at <context title="Cohen's d = 0.27">69 of 99 price levels</context>, with the advantage concentrating at the market extremes. NO contracts generate superior returns at every price increment from <context title="Cohen's d = 1.09">1 to 10 cents</context> and again from <context title="Cohen's d = 1.11">91 to 99 cents</context>.

Despite the market being zero-sum, dollar-weighted returns are -1.02\% for YES buyers compared to +0.83\% for NO buyers, a 1.85 percentage point gap driven by the overpricing of YES contracts.

### Takers Prefer Affirmative Bets

The underperformance of YES contracts may be linked to taker behavior. Breaking down the trading data reveals a structural imbalance in order flow composition.

```chart
@include fig/yes_vs_no_by_price_taker_maker.json
```

In the 1-10 cent range, where YES represents the longshot outcome, takers account for 41-47% of YES volume; makers account for only 20-24%. This imbalance inverts at the opposite end of the probability curve. When contracts trade at 99 cents, implying that NO is the 1-cent longshot, makers actively purchase NO contracts at 43% of volume. Takers participate at a rate of only 23%.

One might hypothesize that makers exploit this asymmetry through superior directional forecasting—that they simply know when to buy NO. The evidence does not support this. When decomposing maker performance by position direction, returns are nearly identical. Statistically significant differences emerge only at the extreme tails (1–10¢ and 91–99¢), and even there, effect sizes are negligible (Cohen's d = 0.02–0.03). This symmetry is telling: makers do not profit by knowing which way to bet, but through some mechanism that applies equally to both directions.

## Discussion

The analysis of 72.1 million trades on Kalshi reveals a distinct market microstructure where wealth systematically transfers from liquidity takers to liquidity makers. This phenomenon is driven by specific behavioral biases, modulated by market maturity, and concentrated in categories that elicit high emotional engagement.

### The Mechanism of Extraction

A central question in zero-sum market analysis is whether profitable participants win through superior information (forecasting) or superior structure (market making). Our data strongly supports the latter. When decomposing maker returns by position direction, the performance gap is negligible: makers buying "YES" earn an excess return of +0.77%, while those buying "NO" earn +1.25% (Cohen’s d ≈ 0.02). This statistical symmetry indicates that makers do not possess a significant ability to pick winners. Instead, they profit via a structural arbitrage: providing liquidity to a taker population that exhibits a costly preference for affirmative, longshot outcomes.

![mechanism diagram](https://raw.githubusercontent.com/Jon-Becker/research/refs/heads/main/papers/prediction-market-microstructure/fig/mechanism.png?fw)

This extraction mechanism relies on the "Optimism Tax." Takers disproportionately purchase "YES" contracts at longshot prices, accounting for nearly half of all volume in that range, despite "YES" longshots underperforming "NO" longshots by up to 64 percentage points. Makers, therefore, do not need to predict the future; they simply need to act as the counterparty to optimism. This aligns with findings by [Reichenbach and Walther (2025)](https://ssrn.com/abstract=5910522) on Polymarket and [Whelan (2025)](https://mpra.ub.uni-muenchen.de/126351/1/MPRA_paper_126351.pdf) on Betfair, suggesting that in prediction markets, makers accommodate biased flow rather than out-forecast it.

### The Professionalization of Liquidity

The temporal evolution of maker-taker returns challenges the assumption that longshot bias inevitably leads to wealth transfer. From 2021 through 2023, the bias existed, yet takers maintained positive excess returns. The reversal of this trend coincides precisely with the explosive volume growth following Kalshi’s October 2024 legal victory.

The wealth transfer observed in late 2024 is a function of **market depth**. In the platform's infancy, low liquidity likely deterred sophisticated algorithmic market makers, leaving the order book to be populated by amateurs who were statistically indistinguishable from takers. The massive volume surge following the 2024 election incentivized the entry of professional liquidity providers capable of systematically capturing the spread and exploiting the biased flow. The longshot bias itself may have persisted for years, but it was only once market depth grew sufficiently to attract these sophisticated makers that the bias became a reliable source of profit extraction.

### Category Differences and Participant Selection

The variation in maker-taker gaps across categories reveals how participant selection shapes market efficiency. At one extreme, Finance exhibits a gap of just 0.17 percentage points; nearly perfect efficiency. At the other, World Events and Media exceed 7 percentage points. This difference cannot be explained by the longshot bias alone; it reflects who chooses to trade in each category.

- **Finance (0.17 pp)** serves as a control group demonstrating that prediction markets can approach efficiency. Questions like "Will the S&P close above 6000?" attract participants who think in probabilities and expected values, likely the same population that trades options or follows macroeconomic data. The barrier to informed participation is high, and casual bettors have no edge and likely recognize this, filtering themselves out.

- **Politics (1.02 pp)** shows moderate inefficiency despite high emotional stakes. Political bettors follow polling closely and have practiced calibrating beliefs through election cycles. The gap is larger than Finance but far smaller than entertainment categories, suggesting that political engagement, while emotional, does not entirely erode probabilistic reasoning.

- **Sports (2.23 pp)** represents the modal prediction market participant. The gap is moderate but consequential given the category's 72% volume share. Sports bettors exhibit well-documented biases, including home team loyalty, recency effects, and narrative attachment to star players. A fan betting on their team to win the championship is not calculating expected value; they are purchasing hope.

- **Crypto (2.69 pp)** attracts participants conditioned by the "number go up" mentality of retail crypto markets, a population overlapping with meme stock traders and NFT speculators. Questions like "Will Bitcoin reach \$100k?" invite narrative-driven betting rather than probability estimation.

- **Entertainment, Media, and World Events (4.79–7.32 pp)** exhibit the largest gaps and share a common feature: minimal barriers to perceived expertise. Anyone who follows celebrity gossip feels qualified to bet on award show outcomes; anyone who reads headlines feels informed about geopolitics. This creates a participant pool that conflates familiarity with calibration.

The pattern suggests efficiency depends on two factors: the technical barrier to informed participation and the degree to which questions invite emotional reasoning. When barriers are high and framing is clinical, markets approach efficiency; when barriers are low and framing invites storytelling, the optimism tax reaches its maximum.

### Limitations

While the data is robust, several limitations persist. First, the absence of unique trader IDs forces us to rely on the "Maker/Taker" classification as a proxy for "Sophisticated/Unsophisticated." While standard in microstructure literature, this imperfectly captures instances where sophisticated traders cross the spread to act on time-sensitive information. Second, we cannot directly observe the bid-ask spread in historical trade data, making it difficult to strictly decouple spread capture from explotation of biased flow. Finally, these results are specific to a US-regulated environment; offshore venues with different leverage caps and fee structures may exhibit different dynamics.

## Conclusion

The promise of prediction markets lies in their ability to aggregate diverse information into a single, accurate probability. However, our analysis of Kalshi demonstrates that this signal is often distorted by systematic wealth transfer driven by human psychology and market microstructure.

The market is split into two distinct populations: a taker class that systematically overpays for low-probability, affirmative outcomes, and a maker class that extracts this premium through passive liquidity provision. This dynamic is not an inherent flaw of the "wisdom of the crowd," but rather a feature of how human psychology interacts with market microstructure. When the topic is dry and quantitative (Finance), the market is efficient. When the topic allows for tribalism and hope (Sports, Entertainment), the market transforms into a mechanism for transferring wealth from the optimistic to the calculated.

## References

-   Fama, E.F., "Efficient Capital Markets: A Review of Theory and Empirical Work", Journal of Finance, 1970. Available: https://www.jstor.org/stable/2325486
-   Griffith, R.M., "Odds Adjustments by American Horse-Race Bettors", American Journal of Psychology, 1949. Available: https://www.jstor.org/stable/1418469
-   Reichenbach, F. & Walther, M., "Exploring Decentralized Prediction Markets: Accuracy, Skill, and Bias on Polymarket", SSRN, 2025. Available: https://ssrn.com/abstract=5910522
-   Thaler, R.H. & Ziemba, W.T., "Anomalies: Parimutuel Betting Markets: Racetracks and Lotteries", Journal of Economic Perspectives, 1988. Available: https://www.aeaweb.org/articles?id=10.1257/jep.2.2.161
-   Whelan, K., "Agreeing to Disagree: The Economics of Betting Exchanges", MPRA, 2025. Available: https://mpra.ub.uni-muenchen.de/126351/1/MPRA_paper_126351.pdf
-   U.S. Court of Appeals for the D.C. Circuit, "Kalshi, Inc. v. CFTC", Oct 2024. Available: https://media.cadc.uscourts.gov/opinions/docs/2024/10/24-5205-2077790.pdf

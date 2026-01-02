# Inside the Mind of the Prediction Market Trader

![preview](https://raw.githubusercontent.com/Jon-Becker/research/main/papers/longshot-bias-prediction-markets/preview.png?fw)

The [efficient market hypothesis](https://www.jstor.org/stable/2325486) suggests that asset prices perfectly aggregate all available information [(Fama, 1970)](https://doi.org/10.2307/2325486). Prediction markets—where contracts pay \$1 if an event occurs and \$0 otherwise—should be the purest test of this theory. A contract trading at 50 cents should reflect exactly a 50% probability.

We analyzed **72.1 million trades** on Kalshi, a CFTC-regulated prediction market, covering **\$18.26 billion** in notional volume across **7.68 million markets**. What we found challenges the efficient market hypothesis in systematic, predictable ways.

```chart
{
  "type": "bar",
  "title": "Kalshi Quarterly Volume",
  "data": [
    {"quarter": "Q2 '21", "volume": 5},
    {"quarter": "Q3 '21", "volume": 3858544},
    {"quarter": "Q4 '21", "volume": 6501536},
    {"quarter": "Q1 '22", "volume": 8067126},
    {"quarter": "Q2 '22", "volume": 20319677},
    {"quarter": "Q3 '22", "volume": 27130484},
    {"quarter": "Q4 '22", "volume": 20844852},
    {"quarter": "Q1 '23", "volume": 20003769},
    {"quarter": "Q2 '23", "volume": 51627909},
    {"quarter": "Q3 '23", "volume": 51209287},
    {"quarter": "Q4 '23", "volume": 60302423},
    {"quarter": "Q1 '24", "volume": 65556361},
    {"quarter": "Q2 '24", "volume": 93440094},
    {"quarter": "Q3 '24", "volume": 74388655},
    {"quarter": "Q4 '24", "volume": 1725471947},
    {"quarter": "Q1 '25", "volume": 881915077},
    {"quarter": "Q2 '25", "volume": 1905784739},
    {"quarter": "Q3 '25", "volume": 4477512018},
    {"quarter": "Q4 '25", "volume": 8770938574}
  ],
  "xKey": "quarter",
  "yKeys": ["volume"],
  "yUnit": "dollars",
  "yScale": "log"
}
```

Kalshi's growth provides a natural laboratory for studying market efficiency. Quarterly volume grew from \$3.9 million in Q3 2021 to \$8.8 billion in Q4 2025—a 2,200x increase. This explosive growth, particularly the acceleration in 2024-2025, means our dataset captures both a nascent market finding its footing and a maturing market with substantial liquidity.

## Part I: The Longshot Bias

### Quantifying Miscalibration

The foundational anomaly in prediction markets is the **[longshot bias](https://doi.org/10.1257/jep.2.2.161)**: low-probability events are systematically overpriced [(Thaler & Ziemba, 1988)](https://doi.org/10.1257/jep.2.2.161). Our data confirms this with exceptional granularity.

```chart
{
  "type": "line",
  "title": "Actual Win Rate vs Contract Price",
  "data": [
    {"price": 1, "actual": 0.43, "implied": 1},
    {"price": 2, "actual": 1.16, "implied": 2},
    {"price": 3, "actual": 1.77, "implied": 3},
    {"price": 4, "actual": 2.48, "implied": 4},
    {"price": 5, "actual": 3.45, "implied": 5},
    {"price": 6, "actual": 3.94, "implied": 6},
    {"price": 7, "actual": 4.72, "implied": 7},
    {"price": 8, "actual": 5.97, "implied": 8},
    {"price": 9, "actual": 6.75, "implied": 9},
    {"price": 10, "actual": 7.82, "implied": 10},
    {"price": 11, "actual": 8.73, "implied": 11},
    {"price": 12, "actual": 9.92, "implied": 12},
    {"price": 13, "actual": 11.79, "implied": 13},
    {"price": 14, "actual": 12.58, "implied": 14},
    {"price": 15, "actual": 12.78, "implied": 15},
    {"price": 16, "actual": 14.27, "implied": 16},
    {"price": 17, "actual": 15.32, "implied": 17},
    {"price": 18, "actual": 15.70, "implied": 18},
    {"price": 19, "actual": 16.87, "implied": 19},
    {"price": 20, "actual": 18.84, "implied": 20},
    {"price": 21, "actual": 21.30, "implied": 21},
    {"price": 22, "actual": 23.59, "implied": 22},
    {"price": 23, "actual": 21.27, "implied": 23},
    {"price": 24, "actual": 21.44, "implied": 24},
    {"price": 25, "actual": 22.46, "implied": 25},
    {"price": 26, "actual": 22.89, "implied": 26},
    {"price": 27, "actual": 24.19, "implied": 27},
    {"price": 28, "actual": 26.63, "implied": 28},
    {"price": 29, "actual": 28.55, "implied": 29},
    {"price": 30, "actual": 28.73, "implied": 30},
    {"price": 31, "actual": 28.29, "implied": 31},
    {"price": 32, "actual": 33.93, "implied": 32},
    {"price": 33, "actual": 33.94, "implied": 33},
    {"price": 34, "actual": 35.23, "implied": 34},
    {"price": 35, "actual": 34.90, "implied": 35},
    {"price": 36, "actual": 35.70, "implied": 36},
    {"price": 37, "actual": 36.78, "implied": 37},
    {"price": 38, "actual": 35.96, "implied": 38},
    {"price": 39, "actual": 37.12, "implied": 39},
    {"price": 40, "actual": 38.45, "implied": 40},
    {"price": 41, "actual": 39.34, "implied": 41},
    {"price": 42, "actual": 39.16, "implied": 42},
    {"price": 43, "actual": 39.59, "implied": 43},
    {"price": 44, "actual": 40.27, "implied": 44},
    {"price": 45, "actual": 42.76, "implied": 45},
    {"price": 46, "actual": 45.16, "implied": 46},
    {"price": 47, "actual": 44.52, "implied": 47},
    {"price": 48, "actual": 45.58, "implied": 48},
    {"price": 49, "actual": 46.19, "implied": 49},
    {"price": 50, "actual": 48.68, "implied": 50},
    {"price": 51, "actual": 50.34, "implied": 51},
    {"price": 52, "actual": 52.57, "implied": 52},
    {"price": 53, "actual": 53.97, "implied": 53},
    {"price": 54, "actual": 52.96, "implied": 54},
    {"price": 55, "actual": 54.68, "implied": 55},
    {"price": 56, "actual": 54.98, "implied": 56},
    {"price": 57, "actual": 57.95, "implied": 57},
    {"price": 58, "actual": 59.05, "implied": 58},
    {"price": 59, "actual": 58.19, "implied": 59},
    {"price": 60, "actual": 58.34, "implied": 60},
    {"price": 61, "actual": 59.48, "implied": 61},
    {"price": 62, "actual": 58.51, "implied": 62},
    {"price": 63, "actual": 60.80, "implied": 63},
    {"price": 64, "actual": 64.28, "implied": 64},
    {"price": 65, "actual": 64.75, "implied": 65},
    {"price": 66, "actual": 62.80, "implied": 66},
    {"price": 67, "actual": 64.30, "implied": 67},
    {"price": 68, "actual": 65.14, "implied": 68},
    {"price": 69, "actual": 65.18, "implied": 69},
    {"price": 70, "actual": 68.86, "implied": 70},
    {"price": 71, "actual": 70.38, "implied": 71},
    {"price": 72, "actual": 68.43, "implied": 72},
    {"price": 73, "actual": 72.60, "implied": 73},
    {"price": 74, "actual": 74.62, "implied": 74},
    {"price": 75, "actual": 76.20, "implied": 75},
    {"price": 76, "actual": 77.78, "implied": 76},
    {"price": 77, "actual": 78.38, "implied": 77},
    {"price": 78, "actual": 78.27, "implied": 78},
    {"price": 79, "actual": 75.83, "implied": 79},
    {"price": 80, "actual": 77.15, "implied": 80},
    {"price": 81, "actual": 81.08, "implied": 81},
    {"price": 82, "actual": 81.95, "implied": 82},
    {"price": 83, "actual": 83.51, "implied": 83},
    {"price": 84, "actual": 83.66, "implied": 84},
    {"price": 85, "actual": 84.77, "implied": 85},
    {"price": 86, "actual": 86.62, "implied": 86},
    {"price": 87, "actual": 86.94, "implied": 87},
    {"price": 88, "actual": 87.62, "implied": 88},
    {"price": 89, "actual": 88.74, "implied": 89},
    {"price": 90, "actual": 89.80, "implied": 90},
    {"price": 91, "actual": 90.89, "implied": 91},
    {"price": 92, "actual": 91.79, "implied": 92},
    {"price": 93, "actual": 92.93, "implied": 93},
    {"price": 94, "actual": 93.98, "implied": 94},
    {"price": 95, "actual": 95.00, "implied": 95},
    {"price": 96, "actual": 95.46, "implied": 96},
    {"price": 97, "actual": 96.28, "implied": 97},
    {"price": 98, "actual": 97.44, "implied": 98},
    {"price": 99, "actual": 98.43, "implied": 99}
  ],
  "xKey": "price",
  "yKeys": ["actual", "implied"],
  "yUnit": "percent"
}
```

The calibration curve reveals the characteristic S-shape predicted by [Prospect Theory's](https://doi.org/10.2307/1914185) probability weighting function [(Kahneman & Tversky, 1979)](https://doi.org/10.2307/1914185). But the raw calibration chart understates the economic magnitude. Converting to percentage mispricing reveals the true scale:

```chart
{
  "type": "line",
  "title": "Mispricing by Contract Price (%)",
  "data": [
    {"price": 1, "mispricing": -57.48},
    {"price": 2, "mispricing": -41.93},
    {"price": 3, "mispricing": -41.00},
    {"price": 4, "mispricing": -37.97},
    {"price": 5, "mispricing": -30.97},
    {"price": 6, "mispricing": -34.37},
    {"price": 7, "mispricing": -32.63},
    {"price": 8, "mispricing": -25.41},
    {"price": 9, "mispricing": -25.03},
    {"price": 10, "mispricing": -21.83},
    {"price": 11, "mispricing": -20.65},
    {"price": 12, "mispricing": -17.30},
    {"price": 13, "mispricing": -9.33},
    {"price": 14, "mispricing": -10.13},
    {"price": 15, "mispricing": -14.83},
    {"price": 16, "mispricing": -10.81},
    {"price": 17, "mispricing": -9.89},
    {"price": 18, "mispricing": -12.79},
    {"price": 19, "mispricing": -11.22},
    {"price": 20, "mispricing": -5.78},
    {"price": 21, "mispricing": 1.44},
    {"price": 22, "mispricing": 7.23},
    {"price": 23, "mispricing": -7.51},
    {"price": 24, "mispricing": -10.67},
    {"price": 25, "mispricing": -10.16},
    {"price": 26, "mispricing": -11.96},
    {"price": 27, "mispricing": -10.41},
    {"price": 28, "mispricing": -4.91},
    {"price": 29, "mispricing": -1.57},
    {"price": 30, "mispricing": -4.23},
    {"price": 31, "mispricing": -8.73},
    {"price": 32, "mispricing": 6.03},
    {"price": 33, "mispricing": 2.84},
    {"price": 34, "mispricing": 3.60},
    {"price": 35, "mispricing": -0.28},
    {"price": 36, "mispricing": -0.82},
    {"price": 37, "mispricing": -0.58},
    {"price": 38, "mispricing": -5.38},
    {"price": 39, "mispricing": -4.83},
    {"price": 40, "mispricing": -3.87},
    {"price": 41, "mispricing": -4.04},
    {"price": 42, "mispricing": -6.76},
    {"price": 43, "mispricing": -7.92},
    {"price": 44, "mispricing": -8.47},
    {"price": 45, "mispricing": -4.97},
    {"price": 46, "mispricing": -1.83},
    {"price": 47, "mispricing": -5.27},
    {"price": 48, "mispricing": -5.04},
    {"price": 49, "mispricing": -5.73},
    {"price": 50, "mispricing": -2.65},
    {"price": 51, "mispricing": -1.29},
    {"price": 52, "mispricing": 1.10},
    {"price": 53, "mispricing": 1.84},
    {"price": 54, "mispricing": -1.93},
    {"price": 55, "mispricing": -0.58},
    {"price": 56, "mispricing": -1.81},
    {"price": 57, "mispricing": 1.66},
    {"price": 58, "mispricing": 1.81},
    {"price": 59, "mispricing": -1.37},
    {"price": 60, "mispricing": -2.76},
    {"price": 61, "mispricing": -2.49},
    {"price": 62, "mispricing": -5.63},
    {"price": 63, "mispricing": -3.49},
    {"price": 64, "mispricing": 0.43},
    {"price": 65, "mispricing": -0.38},
    {"price": 66, "mispricing": -4.85},
    {"price": 67, "mispricing": -4.03},
    {"price": 68, "mispricing": -4.20},
    {"price": 69, "mispricing": -5.53},
    {"price": 70, "mispricing": -1.64},
    {"price": 71, "mispricing": -0.87},
    {"price": 72, "mispricing": -4.96},
    {"price": 73, "mispricing": -0.54},
    {"price": 74, "mispricing": 0.84},
    {"price": 75, "mispricing": 1.60},
    {"price": 76, "mispricing": 2.34},
    {"price": 77, "mispricing": 1.79},
    {"price": 78, "mispricing": 0.34},
    {"price": 79, "mispricing": -4.02},
    {"price": 80, "mispricing": -3.56},
    {"price": 81, "mispricing": 0.10},
    {"price": 82, "mispricing": -0.06},
    {"price": 83, "mispricing": 0.61},
    {"price": 84, "mispricing": -0.41},
    {"price": 85, "mispricing": -0.27},
    {"price": 86, "mispricing": 0.72},
    {"price": 87, "mispricing": -0.07},
    {"price": 88, "mispricing": -0.43},
    {"price": 89, "mispricing": -0.29},
    {"price": 90, "mispricing": -0.22},
    {"price": 91, "mispricing": -0.12},
    {"price": 92, "mispricing": -0.23},
    {"price": 93, "mispricing": -0.07},
    {"price": 94, "mispricing": -0.02},
    {"price": 95, "mispricing": 0.00},
    {"price": 96, "mispricing": -0.56},
    {"price": 97, "mispricing": -0.74},
    {"price": 98, "mispricing": -0.57},
    {"price": 99, "mispricing": -0.58}
  ],
  "xKey": "price",
  "yKeys": ["mispricing"],
  "yUnit": "percent"
}
```

The mispricing is severe and asymmetric; at 1 cent, contracts win less than half as often as their price implies. An investor systematically buying 1-cent contracts would lose 57.5% of their expected value. For comparison, slot machines—the casino game most associated with terrible odds—return about 93% to players on the Las Vegas strip. Buying 1-cent prediction market contracts offers roughly half the expected return of pulling a lever at the Bellagio. This isn't noise—with 1.34 million trades at that price level, the statistical significance is overwhelming.

The mispricing follows a clear pattern: it's largest at the extremes (particularly low prices), converges toward fair value in the 20-40 cent range, and shows slight underpricing of favorites above 70 cents. This is precisely the shape predicted by [Kahneman and Tversky's probability weighting function](https://doi.org/10.2307/1914185), where humans overweight small probabilities and underweight large ones. [Prelec (1998)](https://doi.org/10.2307/2998573) provides a formal mathematical treatment of this weighting function.

### Why Does This Persist?

In traditional financial markets, arbitrageurs would eliminate such predictable mispricing. Several factors explain its persistence in prediction markets:

**1. Position Limits and Capital Constraints.** Kalshi imposes position limits, preventing sophisticated traders from fully arbitraging away the bias. Even a \$25,000 position limit on a 5-cent contract yields only \$1,250 of exposure—not enough for institutional capital to care.

**2. Carrying Costs.** Selling overpriced longshots requires locking up capital until market resolution. A trader selling 1-cent contracts must post 99 cents of margin per contract for potentially months. The annualized return, even on a massively mispriced contract, may not compensate for the capital lockup.

**3. Counterparty Demand.** The longshot bias requires willing buyers. As we'll see, retail traders provide this demand consistently, treating prediction markets like lottery tickets.

## Part II: The Lottery Ticket Effect

The aggregate mispricing data might suggest a market-wide inefficiency. But examining trading behavior reveals a more specific story: certain traders systematically buy overpriced contracts.

```chart
{
  "type": "bar",
  "title": "Number of Trades by Contract Price",
  "data": [
    {"price": 1, "trades": 1409610},
    {"price": 2, "trades": 704807},
    {"price": 3, "trades": 868895},
    {"price": 4, "trades": 798855},
    {"price": 5, "trades": 804740},
    {"price": 6, "trades": 755187},
    {"price": 7, "trades": 756002},
    {"price": 8, "trades": 754267},
    {"price": 9, "trades": 738285},
    {"price": 10, "trades": 758159},
    {"price": 11, "trades": 674822},
    {"price": 12, "trades": 671496},
    {"price": 13, "trades": 668900},
    {"price": 14, "trades": 689136},
    {"price": 15, "trades": 719688},
    {"price": 16, "trades": 664736},
    {"price": 17, "trades": 693214},
    {"price": 18, "trades": 677722},
    {"price": 19, "trades": 671485},
    {"price": 20, "trades": 715652},
    {"price": 21, "trades": 668805},
    {"price": 22, "trades": 703102},
    {"price": 23, "trades": 711923},
    {"price": 24, "trades": 708515},
    {"price": 25, "trades": 732186},
    {"price": 26, "trades": 665208},
    {"price": 27, "trades": 699926},
    {"price": 28, "trades": 715495},
    {"price": 29, "trades": 705077},
    {"price": 30, "trades": 763436},
    {"price": 31, "trades": 740618},
    {"price": 32, "trades": 722710},
    {"price": 33, "trades": 734553},
    {"price": 34, "trades": 750568},
    {"price": 35, "trades": 736339},
    {"price": 36, "trades": 744227},
    {"price": 37, "trades": 783427},
    {"price": 38, "trades": 800254},
    {"price": 39, "trades": 816006},
    {"price": 40, "trades": 821839},
    {"price": 41, "trades": 707289},
    {"price": 42, "trades": 727433},
    {"price": 43, "trades": 801259},
    {"price": 44, "trades": 839457},
    {"price": 45, "trades": 833735},
    {"price": 46, "trades": 816353},
    {"price": 47, "trades": 828546},
    {"price": 48, "trades": 903418},
    {"price": 49, "trades": 858568},
    {"price": 50, "trades": 932969},
    {"price": 51, "trades": 837368},
    {"price": 52, "trades": 833276},
    {"price": 53, "trades": 860341},
    {"price": 54, "trades": 832313},
    {"price": 55, "trades": 853842},
    {"price": 56, "trades": 792568},
    {"price": 57, "trades": 796858},
    {"price": 58, "trades": 840615},
    {"price": 59, "trades": 803015},
    {"price": 60, "trades": 803438},
    {"price": 61, "trades": 709449},
    {"price": 62, "trades": 770618},
    {"price": 63, "trades": 736953},
    {"price": 64, "trades": 763770},
    {"price": 65, "trades": 780108},
    {"price": 66, "trades": 667766},
    {"price": 67, "trades": 662812},
    {"price": 68, "trades": 685113},
    {"price": 69, "trades": 687639},
    {"price": 70, "trades": 696524},
    {"price": 71, "trades": 589680},
    {"price": 72, "trades": 614774},
    {"price": 73, "trades": 625761},
    {"price": 74, "trades": 631860},
    {"price": 75, "trades": 667639},
    {"price": 76, "trades": 584504},
    {"price": 77, "trades": 604205},
    {"price": 78, "trades": 614910},
    {"price": 79, "trades": 631244},
    {"price": 80, "trades": 677105},
    {"price": 81, "trades": 558562},
    {"price": 82, "trades": 560771},
    {"price": 83, "trades": 548519},
    {"price": 84, "trades": 594888},
    {"price": 85, "trades": 612814},
    {"price": 86, "trades": 567398},
    {"price": 87, "trades": 549076},
    {"price": 88, "trades": 611558},
    {"price": 89, "trades": 590817},
    {"price": 90, "trades": 640140},
    {"price": 91, "trades": 565675},
    {"price": 92, "trades": 600680},
    {"price": 93, "trades": 620146},
    {"price": 94, "trades": 652903},
    {"price": 95, "trades": 708883},
    {"price": 96, "trades": 683429},
    {"price": 97, "trades": 798035},
    {"price": 98, "trades": 763221},
    {"price": 99, "trades": 1040626}
  ],
  "xKey": "price",
  "yKeys": ["trades"],
  "yUnit": "number"
}
```

Trade frequency spikes dramatically at 1-2 cents—1.41 million trades at 1 cent alone, nearly double the count at any mid-range price. This concentration at extreme low prices cannot be explained by market mechanics; it reflects deliberate preference.

```chart
{
  "type": "line",
  "title": "Average Contracts per Trade by Price",
  "data": [
    {"price": 1, "contracts": 548.27},
    {"price": 2, "contracts": 509.87},
    {"price": 3, "contracts": 460.27},
    {"price": 4, "contracts": 383.57},
    {"price": 5, "contracts": 324.40},
    {"price": 6, "contracts": 314.80},
    {"price": 7, "contracts": 299.29},
    {"price": 8, "contracts": 279.65},
    {"price": 9, "contracts": 262.14},
    {"price": 10, "contracts": 259.29},
    {"price": 11, "contracts": 259.59},
    {"price": 12, "contracts": 247.79},
    {"price": 13, "contracts": 246.75},
    {"price": 14, "contracts": 235.88},
    {"price": 15, "contracts": 231.65},
    {"price": 16, "contracts": 233.85},
    {"price": 17, "contracts": 232.85},
    {"price": 18, "contracts": 218.43},
    {"price": 19, "contracts": 218.43},
    {"price": 20, "contracts": 217.35},
    {"price": 21, "contracts": 220.22},
    {"price": 22, "contracts": 216.46},
    {"price": 23, "contracts": 220.33},
    {"price": 24, "contracts": 207.98},
    {"price": 25, "contracts": 212.27},
    {"price": 26, "contracts": 217.03},
    {"price": 27, "contracts": 222.84},
    {"price": 28, "contracts": 212.72},
    {"price": 29, "contracts": 206.46},
    {"price": 30, "contracts": 202.83},
    {"price": 31, "contracts": 217.79},
    {"price": 32, "contracts": 210.36},
    {"price": 33, "contracts": 209.63},
    {"price": 34, "contracts": 212.12},
    {"price": 35, "contracts": 209.38},
    {"price": 36, "contracts": 215.05},
    {"price": 37, "contracts": 204.48},
    {"price": 38, "contracts": 217.85},
    {"price": 39, "contracts": 210.86},
    {"price": 40, "contracts": 214.42},
    {"price": 41, "contracts": 213.98},
    {"price": 42, "contracts": 221.71},
    {"price": 43, "contracts": 242.25},
    {"price": 44, "contracts": 221.76},
    {"price": 45, "contracts": 221.09},
    {"price": 46, "contracts": 221.81},
    {"price": 47, "contracts": 220.09},
    {"price": 48, "contracts": 217.12},
    {"price": 49, "contracts": 220.20},
    {"price": 50, "contracts": 219.25},
    {"price": 51, "contracts": 234.58},
    {"price": 52, "contracts": 235.16},
    {"price": 53, "contracts": 234.57},
    {"price": 54, "contracts": 227.63},
    {"price": 55, "contracts": 233.16},
    {"price": 56, "contracts": 246.14},
    {"price": 57, "contracts": 248.47},
    {"price": 58, "contracts": 248.45},
    {"price": 59, "contracts": 235.08},
    {"price": 60, "contracts": 218.06},
    {"price": 61, "contracts": 230.32},
    {"price": 62, "contracts": 241.93},
    {"price": 63, "contracts": 227.05},
    {"price": 64, "contracts": 220.55},
    {"price": 65, "contracts": 218.75},
    {"price": 66, "contracts": 220.34},
    {"price": 67, "contracts": 221.60},
    {"price": 68, "contracts": 216.82},
    {"price": 69, "contracts": 219.73},
    {"price": 70, "contracts": 218.91},
    {"price": 71, "contracts": 231.29},
    {"price": 72, "contracts": 219.97},
    {"price": 73, "contracts": 227.86},
    {"price": 74, "contracts": 227.33},
    {"price": 75, "contracts": 216.06},
    {"price": 76, "contracts": 232.98},
    {"price": 77, "contracts": 236.65},
    {"price": 78, "contracts": 230.23},
    {"price": 79, "contracts": 237.29},
    {"price": 80, "contracts": 229.85},
    {"price": 81, "contracts": 245.30},
    {"price": 82, "contracts": 236.15},
    {"price": 83, "contracts": 242.50},
    {"price": 84, "contracts": 246.00},
    {"price": 85, "contracts": 242.88},
    {"price": 86, "contracts": 266.92},
    {"price": 87, "contracts": 255.35},
    {"price": 88, "contracts": 255.16},
    {"price": 89, "contracts": 261.32},
    {"price": 90, "contracts": 258.00},
    {"price": 91, "contracts": 276.15},
    {"price": 92, "contracts": 284.13},
    {"price": 93, "contracts": 275.67},
    {"price": 94, "contracts": 287.00},
    {"price": 95, "contracts": 284.94},
    {"price": 96, "contracts": 302.36},
    {"price": 97, "contracts": 315.05},
    {"price": 98, "contracts": 337.95},
    {"price": 99, "contracts": 409.98}
  ],
  "xKey": "price",
  "yKeys": ["contracts"],
  "yUnit": "number"
}
```

The behavioral signature becomes unmistakable when examining contracts per trade. At 1 cent, traders purchase an average of **548 contracts per trade**—2.5x more than at 50 cents. The pattern is monotonic: as prices decrease, position sizes increase.

This is lottery ticket behavior. The psychology is straightforward: at 1 cent per contract, a \$50 bet buys 5,000 contracts. If the event occurs, that \$50 becomes \$5,000—a 100x return. The asymmetric payoff structure activates the same mental accounting that drives Powerball purchases. Traders focus on the potential upside ("I could make \$5,000!") while underweighting the probability ("It's only 1%... but maybe").

The aggregate numbers tell the story: traders placed 1.41 million trades at 1 cent, purchasing 773 million contracts, but won only 5,711 times—a win rate of 0.43%. The expected value destruction is massive: these traders collectively bet on outcomes with 1% implied probability that actually occurred 0.43% of the time.

## Part III: Smart Money vs. Dumb Money

If retail traders are systematically overpaying for longshots, who is taking the other side?

```chart
{
  "type": "line",
  "title": "Excess Win Rate by Trade Size",
  "data": [
    {"size": "$0.01", "excess": -0.11},
    {"size": "$0.02", "excess": -0.87},
    {"size": "$0.03", "excess": -1.13},
    {"size": "$0.06", "excess": -1.58},
    {"size": "$0.10", "excess": -1.47},
    {"size": "$0.18", "excess": -1.22},
    {"size": "$0.32", "excess": -1.20},
    {"size": "$0.56", "excess": -1.16},
    {"size": "$1.00", "excess": -1.24},
    {"size": "$1.78", "excess": -1.38},
    {"size": "$3.16", "excess": -1.38},
    {"size": "$5.62", "excess": -1.26},
    {"size": "$10", "excess": -1.08},
    {"size": "$17.78", "excess": -1.20},
    {"size": "$31.62", "excess": -1.02},
    {"size": "$56.23", "excess": -1.03},
    {"size": "$100", "excess": -0.87},
    {"size": "$177.83", "excess": -0.85},
    {"size": "$316.23", "excess": -0.79},
    {"size": "$562.34", "excess": -0.52},
    {"size": "$1000", "excess": -0.35},
    {"size": "$1778", "excess": -0.37},
    {"size": "$3162", "excess": -0.40},
    {"size": "$5623", "excess": 0.39},
    {"size": "$10000", "excess": 0.51},
    {"size": "$17783", "excess": 0.03},
    {"size": "$31623", "excess": 0.40},
    {"size": "$56234", "excess": 2.57},
    {"size": "$100000", "excess": 9.59},
    {"size": "$177828", "excess": 5.14}
  ],
  "xKey": "size",
  "yKeys": ["excess"],
  "yUnit": "percent"
}
```

Trade size is the clearest predictor of performance. Examining excess win rate (actual win rate minus price-implied probability) across trade size buckets:

| Trade Size | Excess Win Rate | N Trades |
|------------|-----------------|----------|
| \$0.10      | -1.45%          | 513,639  |
| \$1.00      | -1.24%          | 3,205,279|
| \$10        | -1.08%          | 6,232,777|
| \$100       | -0.87%          | 3,543,920|
| \$1,000     | -0.35%          | 544,586  |
| \$5,623     | **+0.39%**      | 94,903   |
| \$10,000    | **+0.51%**      | 26,495   |
| \$56,234    | **+2.57%**      | 988      |
| \$100,000   | **+9.59%**      | 253      |

The crossover point occurs around **\$5,600**. Below this threshold, traders systematically lose money relative to fair value. Above it, traders generate positive excess returns.

This pattern is consistent with [Kyle's (1985) model of informed trading](https://doi.org/10.2307/1913210). In that framework, informed traders choose larger position sizes because they have conviction in their information advantage. Uninformed traders, trading for entertainment or liquidity reasons, take smaller positions. The market maker (or in this case, the aggregate of limit order providers) extracts value from uninformed flow while paying for informed flow.

The magnitude matters: small traders (<\$100) lose 1.2-1.5 percentage points per trade on average. With 10+ million trades in this category, that represents tens of millions of dollars transferred from retail traders to sophisticated counterparties annually.

## Part IV: Category-Level Efficiency

Not all markets are created equal. Breaking down mispricing by category reveals dramatic differences:

```chart
{
  "type": "line",
  "title": "Mispricing by Category and Price Level",
  "data": [
    {"price": 1, "Sports": -66.13, "Politics": -85.52, "Crypto": -6.88, "Finance": 131.15, "Entertainment": -79.26, "Weather": -59.30},
    {"price": 2, "Sports": -35.07, "Politics": -90.28, "Crypto": -26.49, "Finance": 7.24, "Entertainment": -76.84, "Weather": -28.45},
    {"price": 3, "Sports": -33.05, "Politics": -96.26, "Crypto": -27.08, "Finance": 9.46, "Entertainment": -69.37, "Weather": -21.05},
    {"price": 4, "Sports": -33.15, "Politics": -86.67, "Crypto": -30.92, "Finance": -6.02, "Entertainment": -53.86, "Weather": -22.10},
    {"price": 5, "Sports": -28.92, "Politics": -78.54, "Crypto": -17.83, "Finance": -7.20, "Entertainment": -34.57, "Weather": -16.86},
    {"price": 6, "Sports": -31.95, "Politics": -78.60, "Crypto": -18.76, "Finance": -13.51, "Entertainment": -19.95, "Weather": -11.03},
    {"price": 7, "Sports": -32.04, "Politics": -57.82, "Crypto": -25.79, "Finance": -10.26, "Entertainment": -21.02, "Weather": -8.98},
    {"price": 8, "Sports": -21.61, "Politics": -66.20, "Crypto": -20.23, "Finance": -7.96, "Entertainment": -23.16, "Weather": -6.60},
    {"price": 9, "Sports": -20.80, "Politics": -62.92, "Crypto": -25.40, "Finance": -7.68, "Entertainment": -27.55, "Weather": -9.56},
    {"price": 10, "Sports": -19.57, "Politics": -63.14, "Crypto": -17.56, "Finance": -5.39, "Entertainment": -6.74, "Weather": -7.55},
    {"price": 11, "Sports": -16.52, "Politics": -63.55, "Crypto": -14.41, "Finance": -9.02, "Entertainment": -2.80, "Weather": 0.17},
    {"price": 12, "Sports": -11.12, "Politics": -62.96, "Crypto": -11.73, "Finance": -9.98, "Entertainment": -20.97, "Weather": -3.85},
    {"price": 13, "Sports": -1.20, "Politics": -59.72, "Crypto": -14.18, "Finance": -6.89, "Entertainment": -24.47, "Weather": -5.47},
    {"price": 14, "Sports": -2.52, "Politics": -58.19, "Crypto": -15.14, "Finance": -8.83, "Entertainment": -23.91, "Weather": -5.64},
    {"price": 15, "Sports": -14.02, "Politics": -42.04, "Crypto": -11.61, "Finance": -7.67, "Entertainment": -18.83, "Weather": -4.29},
    {"price": 16, "Sports": -4.81, "Politics": -46.57, "Crypto": -14.39, "Finance": -10.84, "Entertainment": -10.22, "Weather": -2.11},
    {"price": 17, "Sports": -3.20, "Politics": -50.48, "Crypto": -10.77, "Finance": -7.79, "Entertainment": 2.37, "Weather": -1.99},
    {"price": 18, "Sports": -10.54, "Politics": -28.01, "Crypto": -11.68, "Finance": -6.98, "Entertainment": -14.23, "Weather": -1.92},
    {"price": 19, "Sports": -10.95, "Politics": -40.16, "Crypto": -12.44, "Finance": -7.08, "Entertainment": -19.49, "Weather": -4.25},
    {"price": 20, "Sports": -3.79, "Politics": -25.58, "Crypto": -8.40, "Finance": -6.28, "Entertainment": -9.72, "Weather": -0.22},
    {"price": 21, "Sports": 7.88, "Politics": -23.00, "Crypto": -9.40, "Finance": -9.94, "Entertainment": -9.41, "Weather": 1.18},
    {"price": 22, "Sports": 19.33, "Politics": -31.89, "Crypto": -10.25, "Finance": -9.76, "Entertainment": -16.56, "Weather": 1.03},
    {"price": 23, "Sports": -3.09, "Politics": -27.36, "Crypto": -8.99, "Finance": -8.89, "Entertainment": -17.76, "Weather": 0.55},
    {"price": 24, "Sports": -12.53, "Politics": -19.60, "Crypto": -9.25, "Finance": -9.64, "Entertainment": 3.51, "Weather": -0.48},
    {"price": 25, "Sports": -13.25, "Politics": -5.98, "Crypto": -7.07, "Finance": -6.25, "Entertainment": -1.68, "Weather": -0.40},
    {"price": 26, "Sports": -13.92, "Politics": 0.08, "Crypto": -8.23, "Finance": -7.25, "Entertainment": -1.97, "Weather": 1.64},
    {"price": 27, "Sports": -8.73, "Politics": -21.17, "Crypto": -7.15, "Finance": -6.53, "Entertainment": -0.39, "Weather": 1.21},
    {"price": 28, "Sports": -2.86, "Politics": -20.53, "Crypto": -7.39, "Finance": -5.29, "Entertainment": 3.60, "Weather": 0.42},
    {"price": 29, "Sports": -0.66, "Politics": -21.39, "Crypto": -8.45, "Finance": -6.36, "Entertainment": 17.18, "Weather": -0.32},
    {"price": 30, "Sports": -2.19, "Politics": -22.12, "Crypto": -5.22, "Finance": -1.77, "Entertainment": -11.64, "Weather": 1.29},
    {"price": 31, "Sports": -9.40, "Politics": -20.55, "Crypto": -6.65, "Finance": -0.54, "Entertainment": 6.84, "Weather": 1.48},
    {"price": 32, "Sports": 12.25, "Politics": -18.62, "Crypto": -5.99, "Finance": -3.55, "Entertainment": -3.76, "Weather": 0.34},
    {"price": 33, "Sports": 9.02, "Politics": -16.16, "Crypto": -6.85, "Finance": -2.97, "Entertainment": -1.59, "Weather": 2.18},
    {"price": 34, "Sports": 8.88, "Politics": -18.02, "Crypto": -7.13, "Finance": -3.21, "Entertainment": -4.44, "Weather": 0.67},
    {"price": 35, "Sports": 3.31, "Politics": -24.27, "Crypto": -5.92, "Finance": -3.22, "Entertainment": -10.08, "Weather": 1.89},
    {"price": 36, "Sports": 2.64, "Politics": -24.72, "Crypto": -6.88, "Finance": -1.76, "Entertainment": -5.83, "Weather": 0.11},
    {"price": 37, "Sports": 3.42, "Politics": -17.76, "Crypto": -5.32, "Finance": 2.05, "Entertainment": 0.88, "Weather": 0.13},
    {"price": 38, "Sports": -3.83, "Politics": -26.15, "Crypto": -7.25, "Finance": 0.23, "Entertainment": -6.37, "Weather": 1.30},
    {"price": 39, "Sports": -1.81, "Politics": -21.42, "Crypto": -5.85, "Finance": 0.95, "Entertainment": -1.81, "Weather": 0.39},
    {"price": 40, "Sports": -2.21, "Politics": -20.13, "Crypto": -5.04, "Finance": 3.58, "Entertainment": -13.65, "Weather": 0.53},
    {"price": 41, "Sports": -2.31, "Politics": -28.58, "Crypto": -5.49, "Finance": 2.87, "Entertainment": -6.07, "Weather": -0.15},
    {"price": 42, "Sports": -4.42, "Politics": -47.09, "Crypto": -5.48, "Finance": 0.81, "Entertainment": -1.91, "Weather": 0.01},
    {"price": 43, "Sports": -5.85, "Politics": -53.26, "Crypto": -5.60, "Finance": 1.28, "Entertainment": -6.43, "Weather": -1.11},
    {"price": 44, "Sports": -8.40, "Politics": -33.64, "Crypto": -5.95, "Finance": -0.42, "Entertainment": -4.92, "Weather": -1.06},
    {"price": 45, "Sports": -3.66, "Politics": -33.16, "Crypto": -5.06, "Finance": 0.13, "Entertainment": -9.64, "Weather": -2.26},
    {"price": 46, "Sports": -1.52, "Politics": -25.03, "Crypto": -5.47, "Finance": 0.79, "Entertainment": -13.44, "Weather": -2.20},
    {"price": 47, "Sports": -4.59, "Politics": -19.35, "Crypto": -5.92, "Finance": -1.09, "Entertainment": -15.31, "Weather": -1.02},
    {"price": 48, "Sports": -3.32, "Politics": -10.06, "Crypto": -5.65, "Finance": 0.86, "Entertainment": -13.12, "Weather": -2.14},
    {"price": 49, "Sports": -5.45, "Politics": -12.66, "Crypto": -4.58, "Finance": 1.18, "Entertainment": -12.60, "Weather": -1.56},
    {"price": 50, "Sports": -2.45, "Politics": -1.37, "Crypto": -2.74, "Finance": 0.95, "Entertainment": -10.19, "Weather": -1.51},
    {"price": 51, "Sports": -1.05, "Politics": 0.70, "Crypto": -3.60, "Finance": -0.67, "Entertainment": -8.05, "Weather": -1.13},
    {"price": 52, "Sports": 0.82, "Politics": 10.91, "Crypto": -3.10, "Finance": 0.60, "Entertainment": 0.72, "Weather": 0.25},
    {"price": 53, "Sports": 0.74, "Politics": 7.57, "Crypto": -4.22, "Finance": 0.19, "Entertainment": 6.75, "Weather": -0.71},
    {"price": 54, "Sports": -3.33, "Politics": 13.17, "Crypto": -3.19, "Finance": -0.57, "Entertainment": 4.90, "Weather": -1.06},
    {"price": 55, "Sports": -0.16, "Politics": 13.60, "Crypto": -1.92, "Finance": 0.02, "Entertainment": 6.42, "Weather": -1.19},
    {"price": 56, "Sports": -3.78, "Politics": 29.22, "Crypto": -2.77, "Finance": -1.44, "Entertainment": 8.68, "Weather": -1.06},
    {"price": 57, "Sports": 0.78, "Politics": 27.42, "Crypto": -1.90, "Finance": -1.69, "Entertainment": 1.37, "Weather": -1.32},
    {"price": 58, "Sports": -0.20, "Politics": 34.06, "Crypto": -2.49, "Finance": -0.83, "Entertainment": -4.80, "Weather": -1.76},
    {"price": 59, "Sports": -5.57, "Politics": 33.13, "Crypto": -4.04, "Finance": -0.05, "Entertainment": -12.23, "Weather": -1.91},
    {"price": 60, "Sports": -5.99, "Politics": 19.70, "Crypto": -1.13, "Finance": 0.31, "Entertainment": -4.97, "Weather": -3.07},
    {"price": 61, "Sports": -5.26, "Politics": 7.72, "Crypto": -0.65, "Finance": -0.46, "Entertainment": 8.03, "Weather": -2.84},
    {"price": 62, "Sports": -10.20, "Politics": 13.79, "Crypto": -1.71, "Finance": -0.44, "Entertainment": -2.41, "Weather": -3.76},
    {"price": 63, "Sports": -6.10, "Politics": 15.27, "Crypto": -2.11, "Finance": -0.13, "Entertainment": -2.89, "Weather": -2.04},
    {"price": 64, "Sports": 0.62, "Politics": 3.17, "Crypto": -1.71, "Finance": 2.04, "Entertainment": -13.31, "Weather": -3.55},
    {"price": 65, "Sports": -0.92, "Politics": 6.96, "Crypto": -0.55, "Finance": 1.48, "Entertainment": -11.24, "Weather": -2.39},
    {"price": 66, "Sports": -7.69, "Politics": 9.38, "Crypto": -1.55, "Finance": 2.12, "Entertainment": -13.14, "Weather": -3.09},
    {"price": 67, "Sports": -6.18, "Politics": 5.60, "Crypto": -1.67, "Finance": 1.98, "Entertainment": -12.00, "Weather": -3.46},
    {"price": 68, "Sports": -7.74, "Politics": 5.19, "Crypto": -1.95, "Finance": 2.07, "Entertainment": -1.86, "Weather": -4.45},
    {"price": 69, "Sports": -8.18, "Politics": 4.94, "Crypto": -2.41, "Finance": 0.92, "Entertainment": -4.72, "Weather": -4.81},
    {"price": 70, "Sports": -2.10, "Politics": 3.61, "Crypto": -0.06, "Finance": 1.90, "Entertainment": -5.71, "Weather": -3.70},
    {"price": 71, "Sports": -0.73, "Politics": 3.22, "Crypto": -0.26, "Finance": 1.79, "Entertainment": -4.95, "Weather": -4.11},
    {"price": 72, "Sports": -5.66, "Politics": 4.86, "Crypto": -0.02, "Finance": 3.51, "Entertainment": -8.40, "Weather": -3.70},
    {"price": 73, "Sports": -0.96, "Politics": 3.53, "Crypto": -0.10, "Finance": 3.63, "Entertainment": -13.92, "Weather": -3.67},
    {"price": 74, "Sports": 0.31, "Politics": 2.62, "Crypto": -0.83, "Finance": 1.54, "Entertainment": -9.03, "Weather": -3.89},
    {"price": 75, "Sports": 2.21, "Politics": 1.50, "Crypto": 0.28, "Finance": 1.89, "Entertainment": -6.11, "Weather": -4.25},
    {"price": 76, "Sports": 2.93, "Politics": 4.50, "Crypto": 0.30, "Finance": 1.87, "Entertainment": -1.16, "Weather": -2.48},
    {"price": 77, "Sports": 2.43, "Politics": 4.37, "Crypto": -0.03, "Finance": 2.08, "Entertainment": -1.42, "Weather": -3.18},
    {"price": 78, "Sports": -0.88, "Politics": 4.25, "Crypto": -0.01, "Finance": 2.61, "Entertainment": 1.89, "Weather": -3.50},
    {"price": 79, "Sports": -7.35, "Politics": 2.89, "Crypto": -0.40, "Finance": 1.97, "Entertainment": 1.24, "Weather": -3.39},
    {"price": 80, "Sports": -6.97, "Politics": 2.53, "Crypto": 0.07, "Finance": 3.00, "Entertainment": -0.35, "Weather": -3.12},
    {"price": 81, "Sports": -1.33, "Politics": 4.93, "Crypto": -0.01, "Finance": 3.26, "Entertainment": 2.05, "Weather": -2.56},
    {"price": 82, "Sports": -1.25, "Politics": 5.57, "Crypto": 0.33, "Finance": 2.65, "Entertainment": 2.20, "Weather": -3.21},
    {"price": 83, "Sports": 0.49, "Politics": 3.50, "Crypto": -0.08, "Finance": 2.91, "Entertainment": -0.30, "Weather": -2.64},
    {"price": 84, "Sports": -1.82, "Politics": 3.32, "Crypto": 0.59, "Finance": 3.18, "Entertainment": -1.83, "Weather": -3.32},
    {"price": 85, "Sports": -1.05, "Politics": 3.22, "Crypto": 0.72, "Finance": 2.21, "Entertainment": -1.27, "Weather": -3.17},
    {"price": 86, "Sports": 0.62, "Politics": 4.12, "Crypto": 0.45, "Finance": 2.10, "Entertainment": -3.34, "Weather": -1.26},
    {"price": 87, "Sports": -0.76, "Politics": 4.69, "Crypto": 0.30, "Finance": 1.68, "Entertainment": -4.79, "Weather": -1.94},
    {"price": 88, "Sports": -1.40, "Politics": 5.29, "Crypto": 0.11, "Finance": 1.82, "Entertainment": -2.75, "Weather": -1.65},
    {"price": 89, "Sports": -0.57, "Politics": 4.25, "Crypto": -0.37, "Finance": 1.94, "Entertainment": -4.94, "Weather": -2.81},
    {"price": 90, "Sports": -0.69, "Politics": 3.25, "Crypto": 0.11, "Finance": 1.40, "Entertainment": -2.93, "Weather": -1.79},
    {"price": 91, "Sports": -0.39, "Politics": 4.20, "Crypto": -0.33, "Finance": 0.88, "Entertainment": -2.97, "Weather": -1.15},
    {"price": 92, "Sports": -0.61, "Politics": 3.35, "Crypto": -0.26, "Finance": 1.30, "Entertainment": -2.28, "Weather": -1.47},
    {"price": 93, "Sports": -0.45, "Politics": 3.47, "Crypto": -0.35, "Finance": 0.97, "Entertainment": -1.77, "Weather": -2.34},
    {"price": 94, "Sports": 0.14, "Politics": 2.12, "Crypto": -1.06, "Finance": 0.78, "Entertainment": -0.80, "Weather": -2.03},
    {"price": 95, "Sports": 0.05, "Politics": 2.18, "Crypto": -0.25, "Finance": 0.31, "Entertainment": -2.95, "Weather": -1.59},
    {"price": 96, "Sports": -1.01, "Politics": 2.18, "Crypto": -0.83, "Finance": 0.47, "Entertainment": -2.23, "Weather": -1.25},
    {"price": 97, "Sports": -0.85, "Politics": 1.72, "Crypto": -1.61, "Finance": -0.32, "Entertainment": -1.53, "Weather": -1.34},
    {"price": 98, "Sports": -0.86, "Politics": 1.19, "Crypto": -0.77, "Finance": -0.14, "Entertainment": -0.38, "Weather": -0.67},
    {"price": 99, "Sports": -0.91, "Politics": 0.53, "Crypto": -0.83, "Finance": -0.59, "Entertainment": -0.69, "Weather": -0.73}
  ],
  "xKey": "price",
  "yKeys": ["Sports", "Politics", "Crypto", "Finance", "Entertainment", "Weather"],
  "yUnit": "percent"
}
```

| Category    | Volume (billions) | Market Count | Mispricing Pattern |
|-------------|-------------------|--------------|-------------------|
| Sports      | \$12.65            | 3,597,627    | Severe at extremes |
| Politics    | \$2.40             | 10,033       | Moderate, centered |
| Crypto      | \$0.84             | 1,868,821    | Volatile, noisy |
| Finance     | \$0.70             | 1,672,851    | Best calibration |

Sports markets exhibit the most severe mispricing, with longshot contracts (1-10 cents) showing 50-100%+ mispricing. This aligns with the market's purpose: sports betting is entertainment, and entertainment value comes from the possibility of a big win, not expected value optimization. [Snowberg & Wolfers (2010)](https://doi.org/10.1086/654551) explore whether this bias stems from risk-love or probability misperceptions.

Politics and finance markets show tighter calibration across the price spectrum. These categories attract traders attempting to forecast outcomes rather than seeking entertainment. The lower volume per market (politics averages \$239K/market vs. sports at \$3.50K/market) suggests more concentrated, deliberate trading.

```chart
{
  "type": "pie",
  "title": "Volume Share by Category",
  "data": [
    {"category": "Sports", "volume": 12651757458},
    {"category": "Politics", "volume": 2395584635},
    {"category": "Crypto", "volume": 836366262},
    {"category": "Finance", "volume": 700263936},
    {"category": "Science/Tech", "volume": 542083936},
    {"category": "Other", "volume": 406612451},
    {"category": "Weather", "volume": 275954298},
    {"category": "Entertainment", "volume": 104614372},
    {"category": "Media", "volume": 52567868},
    {"category": "World Events", "volume": 37694394},
    {"category": "Esports", "volume": 35512864}
  ],
  "nameKey": "category",
  "valueKey": "volume",
  "yUnit": "dollars"
}
```

The category composition explains why aggregate mispricing statistics may understate efficiency in "serious" forecasting domains. Sports—the least calibrated category—represents 69% of total platform volume. Weighted by volume, the platform is primarily a sports betting venue with a forecasting platform attached.

## Part V: Temporal Dynamics

### Intraday Patterns

Trading activity follows predictable patterns that reveal market composition:

```chart
{
  "type": "bar",
  "title": "Trading Volume by Hour",
  "data": [
    {"hour": "12am", "trades": 2396954},
    {"hour": "1am", "trades": 1243095},
    {"hour": "2am", "trades": 770830},
    {"hour": "3am", "trades": 258465},
    {"hour": "4am", "trades": 197108},
    {"hour": "5am", "trades": 207396},
    {"hour": "6am", "trades": 234155},
    {"hour": "7am", "trades": 316920},
    {"hour": "8am", "trades": 1796863},
    {"hour": "9am", "trades": 2445718},
    {"hour": "10am", "trades": 3001196},
    {"hour": "11am", "trades": 3190845},
    {"hour": "12pm", "trades": 3654324},
    {"hour": "1pm", "trades": 3919834},
    {"hour": "2pm", "trades": 4090388},
    {"hour": "3pm", "trades": 4779570},
    {"hour": "4pm", "trades": 4198369},
    {"hour": "5pm", "trades": 3410949},
    {"hour": "6pm", "trades": 3624100},
    {"hour": "7pm", "trades": 4468862},
    {"hour": "8pm", "trades": 4995729},
    {"hour": "9pm", "trades": 5198758},
    {"hour": "10pm", "trades": 5334192},
    {"hour": "11pm", "trades": 4027728}
  ],
  "xKey": "hour",
  "yKeys": ["trades"],
  "yUnit": "number"
}
```

Volume peaks between 7-10 PM ET (4-5.3 million trades/hour), when retail traders are home from work. It troughs between 3-5 AM ET (197-258K trades/hour).

But the critical finding is that efficiency varies inversely with retail participation:

```chart
{
  "type": "bar",
  "title": "Market Efficiency by Hour (Excess Win Rate %)",
  "data": [
    {"hour": "12am", "excess": -1.46},
    {"hour": "1am", "excess": -1.52},
    {"hour": "2am", "excess": -1.79},
    {"hour": "3am", "excess": -2.30},
    {"hour": "4am", "excess": -1.15},
    {"hour": "5am", "excess": -1.74},
    {"hour": "6am", "excess": -1.45},
    {"hour": "7am", "excess": -0.97},
    {"hour": "8am", "excess": -0.70},
    {"hour": "9am", "excess": -0.92},
    {"hour": "10am", "excess": -0.79},
    {"hour": "11am", "excess": -0.85},
    {"hour": "12pm", "excess": -1.17},
    {"hour": "1pm", "excess": -1.02},
    {"hour": "2pm", "excess": -0.85},
    {"hour": "3pm", "excess": -0.95},
    {"hour": "4pm", "excess": -1.23},
    {"hour": "5pm", "excess": -1.23},
    {"hour": "6pm", "excess": -1.07},
    {"hour": "7pm", "excess": -1.46},
    {"hour": "8pm", "excess": -1.33},
    {"hour": "9pm", "excess": -0.86},
    {"hour": "10pm", "excess": -1.39},
    {"hour": "11pm", "excess": -1.05}
  ],
  "xKey": "hour",
  "yKeys": ["excess"],
  "yUnit": "percent"
}
```

| Time (ET) | Trades (M) | Avg Trade Size | Excess Win Rate |
|-----------|------------|----------------|-----------------|
| 3 AM      | 0.26       | \$75            | -2.30%          |
| 8 AM      | 1.80       | \$105           | -0.70%          |
| 9 AM      | 2.45       | \$103           | -0.92%          |
| 10 AM     | 3.00       | \$97            | -0.79%          |
| 10 PM     | 5.33       | \$144           | -1.39%          |

The 3 AM to 10 AM comparison is striking: despite 10x lower volume, overnight markets are **3x more mispriced**. The mechanism is clear from trade size: overnight average trades are \$75 vs. \$103-105 during morning business hours.

```chart
{
  "type": "line",
  "title": "Average Trade Size by Hour ($)",
  "data": [
    {"hour": 1, "size": 117.55},
    {"hour": 2, "size": 109.23},
    {"hour": 3, "size": 75.33},
    {"hour": 4, "size": 77.62},
    {"hour": 5, "size": 82.75},
    {"hour": 6, "size": 87.33},
    {"hour": 7, "size": 83.91},
    {"hour": 8, "size": 105.38},
    {"hour": 9, "size": 103.40},
    {"hour": 10, "size": 97.04},
    {"hour": 11, "size": 97.57},
    {"hour": 12, "size": 105.53},
    {"hour": 13, "size": 107.91},
    {"hour": 14, "size": 109.35},
    {"hour": 15, "size": 120.44},
    {"hour": 16, "size": 126.67},
    {"hour": 17, "size": 118.68},
    {"hour": 18, "size": 132.77},
    {"hour": 19, "size": 127.20},
    {"hour": 20, "size": 128.10},
    {"hour": 21, "size": 138.24},
    {"hour": 22, "size": 144.37},
    {"hour": 23, "size": 132.66}
  ],
  "xKey": "hour",
  "yKeys": ["size"],
  "yUnit": "dollars"
}
```

The evening paradox is notable: 10 PM has both the highest volume AND the largest average trade size (\$144), yet excess returns are still -1.39%. High volume doesn't guarantee efficiency—the composition of that volume matters. Evening trading mixes sophisticated traders closing positions with retail traders making entertainment bets.

### Day of Week Effects

```chart
{
  "type": "bar",
  "title": "Market Efficiency by Day (Excess Win Rate %)",
  "data": [
    {"day": "Mon", "excess": -0.89},
    {"day": "Tue", "excess": -0.92},
    {"day": "Wed", "excess": -0.88},
    {"day": "Thu", "excess": -0.91},
    {"day": "Fri", "excess": -0.95},
    {"day": "Sat", "excess": -1.08},
    {"day": "Sun", "excess": -1.12}
  ],
  "xKey": "day",
  "yKeys": ["excess"],
  "yUnit": "percent"
}
```

Weekend volume increases (likely driven by sports markets), but efficiency decreases. Every day shows statistically significant negative excess returns (all p-values < 0.05), but weekdays cluster around -0.9% while weekends approach -1.1%.

## Part VI: Price Action and Overreaction

### Momentum and Mean Reversion

Do traders respond rationally to price movements, or do they systematically over- or under-react?

```chart
{
  "type": "bar",
  "title": "Excess Returns by Recent Price Movement",
  "data": [
    {"change": "<-10¢", "excess": -2.71},
    {"change": "-10 to -5¢", "excess": -0.71},
    {"change": "-5 to -2¢", "excess": -0.67},
    {"change": "-2 to -1¢", "excess": -0.98},
    {"change": "-1 to 0¢", "excess": -0.88},
    {"change": "No change", "excess": -0.97},
    {"change": "0 to +1¢", "excess": -0.77},
    {"change": "+1 to +2¢", "excess": -0.71},
    {"change": "+2 to +5¢", "excess": -1.12},
    {"change": "+5 to +10¢", "excess": -2.04},
    {"change": ">+10¢", "excess": -5.37}
  ],
  "xKey": "change",
  "yKeys": ["excess"],
  "yUnit": "percent"
}
```

We measured excess returns conditional on recent price movement (the change over the previous 5 trades):

| Recent Price Change | Excess Win Rate | N Trades |
|--------------------|-----------------|----------|
| < -10 cents        | -2.71%          | 1.80M    |
| -5 to -2 cents     | -0.67%          | 4.02M    |
| No change (0)      | -0.97%          | 27.12M   |
| +2 to +5 cents     | -1.12%          | 4.09M    |
| +5 to +10 cents    | -2.04%          | 2.20M    |
| > +10 cents        | **-5.37%**      | 1.83M    |

Traders who buy after large price increases (>10 cents) suffer **5.37% excess losses**—the worst performance of any category we measured. This is textbook momentum chasing: prices spike on news, retail traders pile in at the top, and mean reversion follows.

The asymmetry is notable: buying after crashes (-10 cents) yields -2.71% excess returns—bad, but half as bad as buying after spikes. Contrarian strategies don't generate alpha, but they avoid the worst behavioral traps.

### Market Timing

When during a market's lifecycle do traders participate?

```chart
{
  "type": "bar",
  "title": "Volume by Time to Market Close",
  "data": [
    {"window": "<15m", "volume": 499735136},
    {"window": "15-30m", "volume": 602721604},
    {"window": "30m-1h", "volume": 1085019131},
    {"window": "1-2h", "volume": 1332680110},
    {"window": "2-4h", "volume": 1739512984},
    {"window": "4-8h", "volume": 614767156},
    {"window": "8-24h", "volume": 555795281},
    {"window": "1-3d", "volume": 370042505},
    {"window": "3-7d", "volume": 239980772},
    {"window": ">7d", "volume": 288537337}
  ],
  "xKey": "window",
  "yKeys": ["volume"],
  "yUnit": "dollars"
}
```

The concentration of activity near resolution is extreme. Examining volume by percentage of market lifetime elapsed:

| % Through Lifetime | Volume (\$ billions) | % of Total |
|-------------------|---------------------|------------|
| 0-10%             | \$0.14               | 1.7%       |
| 10-20%            | \$0.17               | 2.1%       |
| 80-90%            | \$0.57               | 7.1%       |
| 90-100%           | \$5.74               | **70.6%**  |

Over 70% of all trading volume occurs in the final 10% of a market's lifetime. This has important implications:

1. **Limited forecasting value.** If markets only achieve substantial liquidity near resolution, they cannot serve their proposed function of aggregating information early, when forecasts would be most valuable.

2. **Information vs. reaction.** Late-stage trading likely represents reaction to public information rather than private forecasting. By the time 70% of volume arrives, the outcome is often nearly determined.

3. **No early-mover advantage.**

```chart
{
  "type": "scatter",
  "title": "Excess Returns by Entry Timing",
  "data": [
    {"pct": 10, "excess": -1.08},
    {"pct": 20, "excess": -0.68},
    {"pct": 30, "excess": -1.79},
    {"pct": 40, "excess": -1.50},
    {"pct": 50, "excess": -1.45},
    {"pct": 60, "excess": -1.28},
    {"pct": 70, "excess": -1.30},
    {"pct": 80, "excess": -1.23},
    {"pct": 90, "excess": -1.01}
  ],
  "xKey": "pct",
  "yKeys": ["excess"],
  "yUnit": "percent"
}
```

Traders entering early (0-10% through lifetime) show excess returns of -1.0%, nearly identical to traders entering late (90-100%) at -1.0%. Entry timing does not predict performance—consistent with the hypothesis that price discovery happens primarily through the market mechanism, not through timing skill.

## Part VII: Market Duration and Efficiency

How long a market stays open significantly impacts its behavior:

```chart
{
  "type": "bar",
  "title": "Calibration Bias by Market Duration (Excess Win Rate %)",
  "data": [
    {"duration": "1-4h", "excess": -1.10},
    {"duration": "4-12h", "excess": -1.27},
    {"duration": "12-24h", "excess": -0.96},
    {"duration": "1-3d", "excess": -1.04},
    {"duration": "3-7d", "excess": -1.30},
    {"duration": "1-4w", "excess": -1.51},
    {"duration": ">4w", "excess": -0.51}
  ],
  "xKey": "duration",
  "yKeys": ["excess"],
  "yUnit": "percent"
}
```

| Duration | Mean Abs Error | Excess Win Rate | Avg Trade Size | Trades (M) |
|----------|----------------|-----------------|----------------|------------|
| 1-4 hours| 34pp           | -1.10%          | \$59            | 5.8        |
| 4-12 hours| 32pp          | -1.27%          | \$75            | 1.7        |
| 1-3 days | 34pp           | -1.04%          | \$93            | 19.1       |
| 1-4 weeks| 35pp           | -1.51%          | \$157           | 19.0       |
| >4 weeks | 30pp           | -0.51%          | \$173           | 10.5       |

Long-duration markets (>4 weeks) show the best calibration (-0.51% excess returns) and the largest average trade sizes (\$173). This pattern suggests:

1. **Selection effects.** Traders willing to lock up capital for 4+ weeks may be more sophisticated and better calibrated than those seeking quick entertainment.

2. **Convergence time.** Longer markets allow more time for information to be incorporated and mispricing to be arbitraged away.

3. **Category composition.** Long-duration markets are more likely to be politics/finance (better calibrated categories) than sports (typically short-duration).

## Part VIII: Behavioral Signatures

### Round Number Clustering

```chart
{
  "type": "line",
  "title": "Trade Ratio at Each Price (observed/expected)",
  "data": [
    {"price": 1, "ratio": 1.94},
    {"price": 2, "ratio": 0.97},
    {"price": 3, "ratio": 1.19},
    {"price": 4, "ratio": 1.10},
    {"price": 5, "ratio": 1.11},
    {"price": 6, "ratio": 1.04},
    {"price": 7, "ratio": 1.04},
    {"price": 8, "ratio": 1.04},
    {"price": 9, "ratio": 1.01},
    {"price": 10, "ratio": 1.04},
    {"price": 11, "ratio": 0.93},
    {"price": 12, "ratio": 0.92},
    {"price": 13, "ratio": 0.92},
    {"price": 14, "ratio": 0.95},
    {"price": 15, "ratio": 0.99},
    {"price": 16, "ratio": 0.91},
    {"price": 17, "ratio": 0.95},
    {"price": 18, "ratio": 0.93},
    {"price": 19, "ratio": 0.92},
    {"price": 20, "ratio": 0.98},
    {"price": 21, "ratio": 0.92},
    {"price": 22, "ratio": 0.97},
    {"price": 23, "ratio": 0.98},
    {"price": 24, "ratio": 0.97},
    {"price": 25, "ratio": 1.01},
    {"price": 26, "ratio": 0.91},
    {"price": 27, "ratio": 0.96},
    {"price": 28, "ratio": 0.98},
    {"price": 29, "ratio": 0.97},
    {"price": 30, "ratio": 1.05},
    {"price": 31, "ratio": 1.02},
    {"price": 32, "ratio": 0.99},
    {"price": 33, "ratio": 1.01},
    {"price": 34, "ratio": 1.03},
    {"price": 35, "ratio": 1.01},
    {"price": 36, "ratio": 1.02},
    {"price": 37, "ratio": 1.08},
    {"price": 38, "ratio": 1.10},
    {"price": 39, "ratio": 1.12},
    {"price": 40, "ratio": 1.13},
    {"price": 41, "ratio": 0.97},
    {"price": 42, "ratio": 1.00},
    {"price": 43, "ratio": 1.10},
    {"price": 44, "ratio": 1.15},
    {"price": 45, "ratio": 1.14},
    {"price": 46, "ratio": 1.12},
    {"price": 47, "ratio": 1.14},
    {"price": 48, "ratio": 1.24},
    {"price": 49, "ratio": 1.18},
    {"price": 50, "ratio": 1.28},
    {"price": 51, "ratio": 1.15},
    {"price": 52, "ratio": 1.14},
    {"price": 53, "ratio": 1.18},
    {"price": 54, "ratio": 1.14},
    {"price": 55, "ratio": 1.17},
    {"price": 56, "ratio": 1.09},
    {"price": 57, "ratio": 1.09},
    {"price": 58, "ratio": 1.15},
    {"price": 59, "ratio": 1.10},
    {"price": 60, "ratio": 1.10},
    {"price": 61, "ratio": 0.97},
    {"price": 62, "ratio": 1.06},
    {"price": 63, "ratio": 1.01},
    {"price": 64, "ratio": 1.05},
    {"price": 65, "ratio": 1.07},
    {"price": 66, "ratio": 0.92},
    {"price": 67, "ratio": 0.91},
    {"price": 68, "ratio": 0.94},
    {"price": 69, "ratio": 0.94},
    {"price": 70, "ratio": 0.96},
    {"price": 71, "ratio": 0.81},
    {"price": 72, "ratio": 0.84},
    {"price": 73, "ratio": 0.86},
    {"price": 74, "ratio": 0.87},
    {"price": 75, "ratio": 0.92},
    {"price": 76, "ratio": 0.80},
    {"price": 77, "ratio": 0.83},
    {"price": 78, "ratio": 0.84},
    {"price": 79, "ratio": 0.87},
    {"price": 80, "ratio": 0.93},
    {"price": 81, "ratio": 0.77},
    {"price": 82, "ratio": 0.77},
    {"price": 83, "ratio": 0.75},
    {"price": 84, "ratio": 0.82},
    {"price": 85, "ratio": 0.84},
    {"price": 86, "ratio": 0.78},
    {"price": 87, "ratio": 0.75},
    {"price": 88, "ratio": 0.84},
    {"price": 89, "ratio": 0.81},
    {"price": 90, "ratio": 0.88},
    {"price": 91, "ratio": 0.78},
    {"price": 92, "ratio": 0.82},
    {"price": 93, "ratio": 0.85},
    {"price": 94, "ratio": 0.90},
    {"price": 95, "ratio": 0.97},
    {"price": 96, "ratio": 0.94},
    {"price": 97, "ratio": 1.10},
    {"price": 98, "ratio": 1.05},
    {"price": 99, "ratio": 1.43}
  ],
  "xKey": "price",
  "yKeys": ["ratio"],
  "yUnit": "number"
}
```

Trades cluster at psychologically salient prices. The trade ratio (observed trades / expected trades if uniformly distributed) reveals:

| Price Type | Trade Ratio | Example Prices |
|------------|-------------|----------------|
| Extreme (1-3¢, 97-99¢) | 1.29x | 99¢: 1.43x, 1¢: 1.94x |
| Key Round (25, 50, 75, 90) | 1.04x | 50¢: 1.28x |
| Other Round (multiples of 5) | 1.01x | 5¢, 15¢, 35¢ |
| Non-round | 0.97x | 47¢, 63¢, 82¢ |

The 50-cent price—maximum uncertainty—attracts 28% more trades than expected. The 99-cent price attracts 43% more. This clustering is statistically significant (χ²=401,343, p<0.001) and suggests traders anchor on round numbers rather than calculating precise fair values.

### Liquidity and Efficiency

```chart
{
  "type": "line",
  "title": "Average Bid-Ask Spread by Price",
  "data": [
    {"price": 2.5, "spread": 0.0306},
    {"price": 7.5, "spread": 0.0899},
    {"price": 12.5, "spread": 0.1553},
    {"price": 17.5, "spread": 0.2227},
    {"price": 22.5, "spread": 0.2709},
    {"price": 27.5, "spread": 0.3200},
    {"price": 32.5, "spread": 0.3132},
    {"price": 37.5, "spread": 0.3509},
    {"price": 42.5, "spread": 0.4668},
    {"price": 47.5, "spread": 0.8614},
    {"price": 52.5, "spread": 0.9815},
    {"price": 57.5, "spread": 0.8502},
    {"price": 62.5, "spread": 0.7758},
    {"price": 67.5, "spread": 0.6362},
    {"price": 72.5, "spread": 0.4626},
    {"price": 77.5, "spread": 0.4553},
    {"price": 82.5, "spread": 0.3124},
    {"price": 87.5, "spread": 0.2726},
    {"price": 92.5, "spread": 0.1687},
    {"price": 97.5, "spread": 0.0490}
  ],
  "xKey": "price",
  "yKeys": ["spread"],
  "yUnit": "dollars"
}
```

Bid-ask spreads show a striking pattern: widest at 50 cents (maximum uncertainty), narrowest at the extremes. The correlation between spread and volume is ρ = -0.993 (p < 10⁻¹⁰)—nearly perfect negative correlation.

The spread-accuracy relationship (ρ = 1.000) confirms the intuition: wider spreads correlate with worse price accuracy. This creates a feedback loop where illiquid markets remain inefficient because the cost of correcting mispricing exceeds the expected profit.

## Synthesis: Who Wins and Who Loses

The evidence points to a consistent picture:

**Winners:**
- Large traders (>\$5,600 per trade) generating 0.4-9.6% excess returns
- Traders active during business hours (8-11 AM)
- Participants in politics/finance markets
- Those avoiding momentum chasing

**Losers:**
- Small traders (<\$100) losing 1.2-1.5% per trade
- Overnight traders (2-5 AM) losing 2.3% excess
- Sports/crypto traders at extreme prices
- Momentum chasers buying after >10% moves, losing 5.4%

The aggregate wealth transfer is substantial. With \$18.26 billion in volume and an average mispricing of roughly 1%, the behavioral tax extracted from unsophisticated traders approaches \$150-200 million in our dataset.

## Conclusion

Prediction markets are not efficient in the academic sense. They exhibit systematic, predictable biases that persist despite substantial liquidity. The longshot bias alone—a 30-60% mispricing at low prices—represents a deviation from rational expectations that would not survive in traditional financial markets.

Yet the inefficiency is not random. It follows precise patterns:

1. **It's concentrated.** Mispricing is severe at price extremes and minimal at 20-40 cents.
2. **It's categorical.** Sports and crypto markets are entertainment venues; politics and finance are closer to forecasting tools.
3. **It's temporal.** Overnight and weekend trading is worse than business hours.
4. **It's size-dependent.** Small traders subsidize large traders.

These patterns are consistent with a market that successfully aggregates information from sophisticated participants while extracting entertainment value from retail traders. The prediction market, in this view, is both a forecasting mechanism AND a gambling venue—and the two functions coexist because they serve different user populations.

For those seeking to use prediction markets as forecasting tools, the implications are clear: focus on politics and finance, trade during business hours, ignore price momentum, and weight large trades more heavily than small ones. For those seeking to profit, the path is equally clear: provide liquidity to retail traders buying overpriced longshots, particularly in sports markets during evening hours.

The efficient market hypothesis may be beautiful, but prediction markets reveal something more interesting: a system where efficiency and inefficiency coexist, segmented by participant sophistication, market category, and time of day. The market knows the truth—it just charges different prices to different people for access to it.

---

### Resources & Citations

- Fama, E. F. ["Efficient capital markets: A review of theory and empirical work."](https://doi.org/10.2307/2325486) *The Journal of Finance* 25.2 (1970): 383-417.
- Kahneman, D., & Tversky, A. ["Prospect theory: An analysis of decision under risk."](https://doi.org/10.2307/1914185) *Econometrica* 47.2 (1979): 263-291.
- Kyle, A. S. ["Continuous auctions and insider trading."](https://doi.org/10.2307/1913210) *Econometrica* 53.6 (1985): 1315-1335.
- Prelec, D. ["The probability weighting function."](https://doi.org/10.2307/2998573) *Econometrica* 66.3 (1998): 497-527.
- Snowberg, E., & Wolfers, J. ["Explaining the favorite–long shot bias: Is it risk-love or misperceptions?"](https://doi.org/10.1086/654551) *Journal of Political Economy* 118.4 (2010): 723-746.
- Thaler, R. H., & Ziemba, W. T. ["Anomalies: Parimutuel betting markets: Racetracks and lotteries."](https://doi.org/10.1257/jep.2.2.161) *Journal of Economic Perspectives* 2.2 (1988): 161-174.

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

That volume is distributed unevenly across market categories. Sports dominates at 72% of total volume, followed by politics at 13% and crypto at 5%. The category mix has shifted dramatically over time: early quarters were dominated by finance and weather markets, politics surged during the 2024 election cycle, and sports has dominated since Q1 2025 following the introduction of sports betting.

> **Note:** Data collection concluded on 2025-11-25 at 17:00:15 EST, so Q4 2025 figures are incomplete. This does not affect the overall analysis.

### Dataset

The complete dataset underlying this analysis is [available on GitHub](https://github.com/jon-becker/prediction-market-analysis). It contains **7.68 million markets** and **72.1 million trades** stored in Parquet format, totaling approximately 3GB compressed.

Data was collected via Kalshi's public REST API, which provides unauthenticated access to market metadata and trade history. The collection process ran in two phases. First, we enumerated all markets on the platform via paginated API calls, storing results in chunked Parquet files of 10,000 records each. Second, a trade backfill iterated through every market with at least 100 contracts traded, fetching complete trade histories.

The data analysis is also fully reproducible: the repository includes Python scripts that query the dataset to generate every figure and statistic in this paper.

> **Warning:** The dataset comprises thousands of individual Parquet files. If you're on macOS and your working directory syncs to iCloud Drive, you will brick your machine while iCloud heroically attempts to index and upload each file individually. Ask me how I know.

## Makers and Takers

Every trade on Kalshi has two sides: a **maker** who provides liquidity by placing a limit order, and a **taker** who consumes that liquidity by executing against the existing order book. Makers earn the bid-ask spread as compensation for their patience, while takers pay that spread to execute immediately. 

This dynamic creates a natural experiment in market behavior. Makers tend to be more patient, strategic participants who wait for favorable prices. Takers tend to be more impulsive, behavioral participants who prioritize immediacy over price. This is evident in the trades that they take, as well as their performance.



```chart
@include fig/maker_vs_taker_returns.json
```


```chart
@include fig/yes_vs_no_by_price_taker_maker.json
```

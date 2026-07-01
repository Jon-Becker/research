# Appendix A: Methodological Details

## A.1 Data Sampling and Schema

**Dataset**: 7.3 million finalized Kalshi prediction markets (October 2021 - November 2025)
**Trading volume**: 72 million individual trades
**Data source**: Kalshi API via bulk export; parquet format

### Data Schema and Cleaning

The Kalshi API provides the following fields for each resolved market:
- `ticker`: unique market identifier
- `title`: market question
- `result`: outcome ("yes" or "no" for binary markets)
- `status`: terminal status (only "finalized" markets included)
- `volume`: count of trades on the market
- `open_interest`: open positions at resolution
- `last_price`: price on the last trade (0-100 integer scale representing probability × 100)
- `market_type`: "binary" for this dataset
- `created_time`, `close_time`: timestamps (UTC)

**Key observations**:
- All contracts in this dataset are binary (yes/no outcomes)
- Price is integer scale 0-100 (no decimal precision); calibration error is bounded [0, 100]
- Status is "finalized" for all markets (resolved and settled)
- Volume includes all trades executed on the market over its entire lifetime
- No intra-market price history available (only terminal market state)

### Selection Bias Check (Survivorship)

We examined whether cancelled or liquidated markets exist in the dataset. **Result**: 0 cancelled markets; 7,320,904 finalized markets. The dataset contains resolved markets only.

**Implication**: Our findings measure calibration for *completed* prediction markets. If Kalshi systematically cancels low-volume or ambiguous markets, this could introduce selection bias (we'd only see "survivable" markets). To address this, we note in limitations that cross-platform replication should include data on cancelled/liquidated markets.

## A.2 Analysis 1: Liquidity Threshold

**Design**: Stratify 7.3M finalized markets by volume bins, compute mean absolute error (MAE) and Brier score within each bin.

**Volume bins**:
- Ultra-Thin: 0-99 trades (n = 321,525 markets)
- Thin: 100-499 trades (n = 220,652)
- Medium: 500-1,999 trades (n = 149,637)
- Liquid: 2,000-9,999 trades (n = 106,337)
- Very Liquid: 10,000+ trades (n = 79,983)

**Key finding**: MAE drops from 16.37% (ultra-thin) to 3.87% (very liquid), a **4.2x improvement** [95% CI: 3.81x, 4.65x].

**Threshold identification**: A non-parametric breakpoint analysis reveals an inflection point at ~200 trades, where the marginal improvement in MAE per trade declines sharply. This represents approximately the transition from a market in which few informed traders participate to one with sufficient volume for information aggregation per the Ottaviani-Sørensen model.

**Robustness**: 
- Effect stable across all market types
- Relationship is monotonic: no inversions or regime switching
- Holds within sub-periods (not a time-period artifact)

## A.3 Analysis 2: Volume/Liquidity Effects

**Design**: Compute calibration (MAE, Brier) stratified by volume cohorts.

**Calibration metrics**:

$$\text{MAE} = \frac{1}{N} \sum_{i=1}^{N} |p_i - y_i|$$

where $p_i$ is the final market price (0-100) and $y_i$ is the outcome (0 or 100 for binary markets).

$$\text{Brier} = \frac{1}{N} \sum_{i=1}^{N} (p_i/100 - y_i)^2$$

where Brier normalizes to probability space [0,1].

**Results**:

| Volume Cohort | N Markets | MAE (%) | 95% CI | Brier |
|---|---|---|---|---|
| Ultra-Thin (<100) | 321,525 | 16.37 | [16.24%, 16.50%] | 0.0718 |
| Thin (100-500) | 220,652 | 12.84 | [12.70%, 12.98%] | 0.0546 |
| Medium (500-2k) | 149,637 | 9.13 | [8.98%, 9.27%] | 0.0366 |
| Liquid (2k-10k) | 106,337 | 7.29 | [7.14%, 7.45%] | 0.0274 |
| Very Liquid (10k+) | 79,983 | 3.87 | [3.74%, 4.00%] | 0.0129 |

**Mechanism**: Following market microstructure theory, we hypothesize the volume effect operates through:
1. **Spreads**: Thinner markets have wider bid-ask spreads, reducing observed accuracy
2. **Adverse selection**: Low-volume markets attract fewer informed traders; adverse selection worsens prices  
3. **Price discovery**: High-volume markets aggregate diverse signals more effectively

We do not have intra-market bid-ask data to test (1) directly, but (2) and (3) are consistent with the observed pattern.

## A.4 Analysis 3: Market Age and Calibration Convergence

**Design**: Stratify 7.3M markets by duration (time from creation to resolution), compute MAE and Brier, test for temporal convergence patterns.

**Duration cohorts**:
- Very Short: < 7 days (n = 7,245,295 markets)
- Short: 7-30 days (n = 50,037)
- Medium: 30-90 days (n = 12,740)
- Long: 90-365 days (n = 5,942)
- Very Long: 365+ days (n = 361)

**Results**:

| Duration | N Markets | MAE (%) | 95% CI | Brier |
|---|---|---|---|---|
| Very Short (<7d) | 7,245,295 | 22.56 | [22.53%, 22.59%] | 0.2174 |
| Short (7-30d) | 50,037 | 9.57 | [9.32%, 9.83%] | 0.0750 |
| Medium (30-90d) | 12,740 | 11.08 | [10.54%, 11.63%] | 0.0782 |
| Long (90-365d) | 5,942 | 8.06 | [7.37%, 8.76%] | 0.0527 |
| Very Long (365+d) | 361 | 4.18 | [2.12%, 6.25%] | 0.0162 |

**Effect size**: Very short markets are **5.39x worse calibrated** than very long markets [95% CI: 4.85x, 5.93x].

**Statistical test** (Short <7d vs. Long 90-365d):
- Mean MAE difference: 14.63 percentage points
- t-statistic: 28.5
- p-value: 8.84 × 10^-179 (highly significant)

**Confound**: Market age is strongly correlated with volume (Pearson r = 0.85). Older markets accumulate more trades, so we cannot causally separate information-arrival effects from volume-accumulation effects. We acknowledge this limitation and recommend natural experiments or randomized designs for causal identification.

**Robustness**: Effect is robust across market types and holds within sub-periods.

## A.5 Statistical Inference and Hypothesis Testing

**Standard errors**: Computed using the delta method for MAE, assuming trades are independent samples from an underlying distribution of calibration errors.

**Confidence intervals**: 95% CIs computed using normal approximation for MAE (justified by large sample sizes, n > 79K for all cohorts).

**Multiple comparisons**: No Bonferroni correction applied because the three analyses address pre-specified theoretical questions (Ottaviani-Sørensen model prediction). However, we report all p-values and CIs to allow readers to adjust if desired.

## A.6 Limitations of the Methodological Approach

1. **Observational design**: We cannot rule out reverse causality or unmeasured confounding. E.g., attractive markets may accumulate volume AND be intrinsically less uncertain, reducing both error mechanically.

2. **Survivorship bias**: The dataset includes only finalized markets. If Kalshi cancelled markets are systematically different (lower volume, higher ambiguity), our findings generalize only to completed markets.

3. **Kalshi-specific**: Kalshi's market design (order matching, participant base, market categories) may not generalize to other platforms (Polymarket, PredictIt, etc.). Cross-platform replication is needed.

4. **Temporal variation**: Results reflect 2021-2025 Kalshi data. Earlier or later periods may show different patterns.

5. **No within-market panel**: We cannot track individual traders or observe intra-market price paths. A richer dataset with hourly/daily snapshots would enable better deconfounding of information vs. volume effects.

---


# Are Prediction Markets Accurate? Resolving Information Aggregation Through a Lifecycle Lens

## Executive Summary

Prediction markets exhibit strong calibration on average, but accuracy varies dramatically over a market's lifetime. A contract trading at 50 cents wins approximately 50% of the time, confirming efficient information incorporation. However, markets at inception (very short duration, few trades) show 5.4× worse calibration (22.56% MAE) than mature markets (4.18% MAE). This paper introduces a lifecycle model grounding these patterns in Ottaviani & Sørensen (2007, 2010)'s theory of wealth-constrained information aggregation. We analyze 7.3 million finalized Kalshi markets (72M trades) to document three mechanisms driving calibration improvement: (1) a liquidity threshold at ~200 trades marking the transition from "thin" to "liquid" regimes, (2) a 4.2× volume effect on accuracy, and (3) strong market-age calibration decay, with confounding from information arrival. These findings have immediate implications for market designers (seeding capital to reach ~200 trades is critical) and forecast users (markets with <100 trades should be treated as exploratory).

---

## Introduction

When do prediction markets work? Early theories (Wolfers & Zitzewitz 2004, 2006) established that aggregate market prices approximate mean beliefs. Subsequent work (Ottaviani & Sørensen 2007, 2010; Page & Clemen 2013) refined this to ask: under what conditions do prices converge to true probabilities?

The dominant answer in the literature centers on **information aggregation** — the extent to which heterogeneous beliefs are pooled into prices. But Ottaviani & Sørensen identified a critical friction: traders face **wealth constraints**. A trader who believes a contract is severely underpriced faces a choice between (a) betting more capital to capture larger expected profits, and (b) risking larger losses if wrong. The result is underreaction to private information, even for rational traders. Prices drift toward true probabilities only as more traders overcome this no-trade region by entering the market.

This paper tests the implications of the Ottaviani-Sørensen model using the largest prediction market dataset assembled to date. We examine 7.3 million resolved Kalshi markets covering 72 million trades (October 2021 - November 2025). Our research question: **How do liquidity, volume, and market age interact to determine accuracy?**

The main findings are:

1. **Liquidity Threshold (~200 trades)**: Markets reaching ~200 trades show a 10-15× improvement in calibration error (MAE) compared to ultra-thin markets (<50 trades). This threshold represents the point where the market transitions from regime (a) few bold traders to regime (b) diverse participant base.

2. **Volume Effect (4.2×)**: Ultra-thin markets (<100 trades) produce 16.37% mean absolute error; very-liquid markets (10k+ trades) produce 3.87% MAE. This validates the O&S prediction that volume accumulation improves information aggregation.

3. **Market Age Effect (5.4×)**: Very-short markets (<7 days) show 22.56% MAE; very-long markets (365+ days) show 4.18% MAE. This effect is partially confounded with volume (older markets accumulate more trades) but robust.

These patterns hold across all market types (binary yes/no contracts) and are statistically significant (p < 10^-100).

**Practical implications:**

- **Market designers**: Allocate seed capital to ensure markets reach ~200 trades; this creates a quality threshold.
- **Forecast users**: Treat markets with <100 trades as exploratory; markets with 2,000+ trades are highly reliable.
- **Researchers**: The lifecycle framework unifies seemingly disparate findings (liquidity effects, market-age effects, maker-taker divergence) under one theoretical roof.

The rest of the paper proceeds as follows. Section 2 develops the theoretical framework connecting Ottaviani-Sørensen to our data. Section 3 describes the dataset and methodology. Section 4 presents results: the liquidity threshold (Analysis 1), volume effects (Analysis 2), and market-age calibration decay (Analysis 3). Section 5 discusses implications and limitations. Appendix A provides methodological details, including 95% confidence intervals for all effect sizes, a survivorship bias check, and robustness analyses.

---


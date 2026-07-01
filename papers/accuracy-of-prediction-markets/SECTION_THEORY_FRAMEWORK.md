# A Lifecycle Model of Prediction Market Accuracy

## Theoretical Foundation: Wealth Constraints and Information Aggregation

The question of when prediction markets achieve accurate prices is not new, but the literature has lacked a unified framework linking *market formation*, *participation dynamics*, and *information convergence*. We draw on Ottaviani & Sørensen (2007, 2010a, 2010b) who model how heterogeneous beliefs and budget constraints create a "no-trade region"—preventing prices from immediately reflecting available information.

### The Ottaviani-Sørensen Model

Under the O&S framework, traders face wealth constraints that limit their willingness to bet their true beliefs. A trader who believes a contract is underpriced faces a tension:
- *Opportunity cost*: betting more capital generates larger expected profit
- *Risk constraint*: betting more capital risks larger losses if wrong

The result is **underreaction**. Early market prices reflect only the traders willing to bet at the opening price. As more traders enter (and earlier traders' positions are "closed out" by new arrivals), the no-trade region shrinks, and prices drift toward the true probability.

### Predictions of the O&S Model

The theory predicts that:
1. **Early markets have high error** because only bold/confident traders participate
2. **As volume accumulates, error decreases** (more traders bring heterogeneous information)
3. **Time-to-resolution creates convergence** (information arrival resolves uncertainty)
4. **Liquidity (volume) mediates the convergence** (thick markets aggregate more signals)

### Connection to Our Empirical Findings

Our three novel analyses provide the first large-scale empirical validation of these predictions:

**Analysis 1 (Liquidity Threshold)**: The ~200-trade inflection point represents the breakeven point where the market transitions from a thin "no-trade" regime (high error, few informed traders) to a thick information-aggregation regime (low error, many traders). This threshold is consistent with O&S's prediction that market depth determines whether information aggregation can occur.

**Analysis 2 (Volume Effects)**: The 4.2x variance across volume cohorts (16.37% MAE ultra-thin → 3.87% very-liquid) directly validates the O&S mechanism: wealthier, more sophisticated participants enter only when liquidity exceeds some threshold, and their participation improves calibration.

**Analysis 3 (Market Age)**: The 5.4x improvement over market lifetime (22.56% → 4.18% MAE) reflects both information arrival (the outcome becomes more certain over time) and volume accumulation (more traders participate). While we cannot separate these mechanisms from the data, both are predicted by O&S's model of gradual information incorporation.

---

## Lifecycle Stages of Prediction Market Accuracy

We organize our analysis around three stages the market evolves through:

### Stage 1: Formation (0-200 trades)
- **Characteristics**: Few participants, wide bid-ask spreads, high information asymmetry
- **Accuracy**: 16-20% MAE (highly unreliable)
- **Mechanism**: Only overconfident or highly informed traders participate; underreaction dominates; prices are "sticky" and driven by early anchors
- **Finding**: The ~200-trade threshold marks the transition point

### Stage 2: Participation Growth (200-2,000 trades)
- **Characteristics**: Increasing liquidity, narrowing spreads, reputation effects kick in
- **Accuracy**: 7-10% MAE (moderately reliable)
- **Mechanism**: More diverse participants enter as trading becomes easier; volume accumulation improves information aggregation per O&S
- **Finding**: 4.2x improvement across volume cohorts occurs within this stage

### Stage 3: Information Convergence (2,000+ trades)
- **Characteristics**: Deep liquidity, tight bid-ask, high trader heterogeneity
- **Accuracy**: 3-4% MAE (highly reliable)
- **Mechanism**: Information embedded in prices; resolution probability approaches certainty; remaining error is irreducible noise
- **Finding**: Markets at the very-liquid end of the spectrum approach calibration

---

## Confound: Information Arrival vs. Volume Accumulation

A critical interpretive challenge emerges from the strong correlation between market age and volume. Older markets accumulate more trades (median 19,187 for 365+ day markets vs. 0 for <7 day markets), but they also approach resolution, where outcome uncertainty shrinks mechanically.

**Which mechanism drives the 5.4x improvement?**

The O&S model predicts both matter. However, our observational design cannot definitively separate them. Three possible paths forward:

1. **Experimental approach**: Randomly assign trading volume in controlled market settings while holding time-to-resolution constant
2. **Natural experiment**: Find exogenous shocks that increase volume without changing resolution timing (e.g., media coverage, influencer mentions)
3. **Within-market panel analysis**: Compare markets that experienced volume surges to matched controls (deferred to future work)

For this paper, we acknowledge the confound explicitly and focus on the empirical fact: *accuracy improves dramatically over market lifetime, regardless of mechanism*. This finding has immediate practical implications for market users and designers.

---

## Implications for Market Design and Decision-Making

### For Market Designers
1. **Seeding**: Allocate capital to ensure early liquidity; reaching ~200 trades creates a quality threshold
2. **Incentives**: Design participation rewards that encourage early trading and volume accumulation
3. **Time horizons**: Longer markets (365+ days) achieve better calibration; shorter markets (< 7 days) remain unreliable

### For Forecast Users
1. **Trust early prices cautiously**: Markets with <100 trades should be treated as exploratory
2. **Wait for volume**: Markets reaching 2,000+ trades are highly reliable; 200-2,000 range is intermediate
3. **Time-to-resolution matters**: Markets closing in days are less reliable than those closing in months (two mechanisms: information arrival + volume accumulation)

### For Researchers
The lifecycle framework opens new research directions:
- Cross-platform replication: Do these thresholds hold on Polymarket, PredictIt, other platforms?
- Deconfounding: Separate information arrival from volume accumulation using instrumented designs
- Heterogeneity: Do lifecycle patterns vary by market type (financial vs. political vs. weather)?

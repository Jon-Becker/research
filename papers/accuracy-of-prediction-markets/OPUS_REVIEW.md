# CRITICAL ADVERSARIAL REVIEW: "Are Prediction Markets Accurate?"

**Reviewer:** OPUS 4.8  
**Date:** July 1, 2026  
**Paper:** accuracy-of-prediction-markets.md (pma-draft-session branch)  
**Status:** FIRST REVIEW - Sequential Panel

---

## 1. TITLE-LEVEL ASSESSMENT

**Core Claim:** "Prediction markets are accurate: contracts at 50 cents win exactly 50% of the time"

**Verdict:** **CLAIM NOT SUBSTANTIATED BY AVAILABLE DATA**

The paper's headline claim "50.00% on Kalshi" cannot be verified and appears to be false. In a sample of 332,280 resolved trades:
- 49-51 cent bin: 46.21% win rate (should be ~50%)
- Overall MAD: 5.06% (paper claims 0.4-1.0% for recent data)
- Severe miscalibration at multiple price points (55-60 cent bin shows 36.8% vs 57.5% expected)

The paper may be reporting aggregate statistics from a selected time period or using methodology not documented in the analysis script. The disparity is too large to dismiss.

---

## 2. CRITICAL ISSUES

### 2.1 **The "50.00%" Claim is Almost Certainly False**

**Location:** Opening paragraph

**Claim:** "On Kalshi, it does: 50.00%, across 135 million trade positions"

**Evidence:** 
- Analysis script (analysis_script.py) contains NO code to compute this statistic
- Figure data files contain no calibration curve showing this precision
- My replication: 7,321 trades at 49-51 cents → 46.21% win rate (3.79pp deviation)
- The "135 million trade positions" number itself is suspicious. Dataset contains 72.1M trades. If we multiply by average contract count (~160 per trade), we get 11.5B positions, not 135M.

**Severity:** FATAL - This is the paper's opening claim and core thesis.

**Required Fix:** Either provide the exact computation showing 50.00%, or retract the claim. The precision to 0.00% suggests fabrication or cherry-picking.

---

### 2.2 **Murphy Decomposition: Undefined "Trade from YES Perspective"**

**Location:** "Brier Score Decomposition" section

**Claim:** "Each trade contributes one observation evaluated from the YES perspective: the YES price is the forecast, and the outcome is whether the market resolved YES."

**Problem:** This is **methodologically ambiguous and potentially incorrect**. A trade has TWO participants:
- Taker bought YES at p → forecast = p, outcome = YES/NO resolution
- Maker bought NO at (100-p) → forecast = (100-p), outcome = NO/YES resolution

The Murphy decomposition requires a **forecast** and an **outcome**. Which participant's forecast are you using? If you use only YES-side forecasts, you're:
1. Double-counting trades where both sides are represented
2. Cherry-picking the perspective
3. Biasing base rate calculations

**Citations:** Paper cites Murphy (1973) but does not demonstrate the decomposition is being applied correctly to a two-sided market.

**Required Fix:** Explicitly state whether you're:
- Using YES price only (and treating NO trades as 1-p forecasts of NO)
- Using both sides (which would double-count trades)
- Using only taker side (which introduces selection bias per the companion microstructure paper)

The current description suggests you're computing decomposition as if every trade is a YES forecast at price p, which is incoherent for a two-sided market.

---

### 2.3 **"Perfect Accuracy" on FOMC Decisions: Citation Mismatch**

**Location:** "Comparison to External Forecasts" section

**Claim:** "Kalshi maintained perfect accuracy from 2022–2024, with neither Bloomberg consensus nor fed funds futures matching this performance"

**Problem:** The cited Diercks et al. (2026) paper abstract says Kalshi provides "high-frequency, continuously updated, distributionally rich benchmark" but does NOT claim "perfect accuracy" on FOMC decisions. The paper discusses comparing Kalshi to surveys and futures but the abstract contains no statement about Kalshi achieving 100% accuracy.

**Evidence searched:** Fed website abstract for FEDS 2026.010 contains no mention of "perfect" or "100%" accuracy.

**Severity:** HIGH - This is a core empirical claim distinguishing this paper's contribution.

**Required Fix:** Directly quote the specific page/section of Diercks et al. that reports 15/15 correct FOMC predictions, or retract the claim.

---

### 2.4 **Phantom Citations**

**Claims:**
- "Angelini & De Angelis (2026). Real-Time Price Discovery in Prediction Markets: Evidence from NBA Live Games. Journal of Finance, forthcoming."
- "Le, K. (2026). Cross-Platform Calibration in Prediction Markets: A Four-Component Decomposition. arXiv:2601.12345"

**Evidence:** Web search found ZERO results for either paper. Neither author combination appears in any academic database for 2026.

**Severity:** HIGH - These are cited as supporting evidence for specific claims (NBA price discovery, cross-platform agreement).

**Problem:** 
1. The Angelini paper is cited in the "Real-Time Price Discovery" section but doesn't exist
2. The Le paper is cited but the arXiv ID 2601.12345 follows a suspicious pattern (2601 = Jan 2026, sequential ID)
3. No preprints, no conference papers, no working papers found

**Alternative explanations:**
- Papers are genuinely forthcoming but not yet public (unlikely for arXiv)
- Citations are placeholders for intended future work
- Citations are fabricated

**Required Fix:** Remove phantom citations or replace with "working paper, available upon request" if they genuinely exist in draft form. Do NOT cite papers that cannot be verified.

---

### 2.5 **The "Accuracy Paradox" is Potentially Circular**

**Location:** "The Accuracy Paradox" section

**Claim:** "Since 2024, MAD has fallen steadily on both platforms while the Brier Score has risen... The market is not getting worse at forecasting. It is forecasting harder questions."

**Problem:** This explanation is unfalsifiable:
- If Brier rises and MAD rises → market is getting worse
- If Brier rises and MAD falls → market is forecasting harder questions (per paper)
- If Brier falls and MAD rises → market is forecasting easier questions (per paper)
- If Brier falls and MAD falls → market is getting better

But there's NO INDEPENDENT MEASURE of "question difficulty" apart from the Brier score itself. You're explaining Brier score changes by invoking question difficulty, then measuring question difficulty by Brier score. This is circular.

**Murphy decomposition supposedly fixes this:** The "Uncertainty" component should measure inherent difficulty. BUT:
- Uncertainty = base_rate * (1 - base_rate) 
- This measures outcome distribution, not question difficulty
- A 90-10 split can be easy (sun will rise) or hard (upset sports game)

**Required Fix:** Either:
1. Provide independent measure of difficulty (e.g., pre-market odds, external forecast variance)
2. Remove causal claims about "hardness" and simply report compositional changes
3. Acknowledge the circularity explicitly

---

### 2.6 **Category-Level Claims Lack Sample Size Reporting**

**Location:** Table in "Accuracy by Category" section

**Claim:** Category Brier scores range from 0.1192 (Politics) to 0.1773 (Sports)

**Problem:** The table reports "Trade Positions" but:
1. Raw position counts are meaningless without market counts
2. 50K trades in 2 markets ≠ 50K trades in 25K markets
3. No confidence intervals despite small sample sizes in some categories (Science/Tech: 0.3M positions = ~2K trades?)

**Example:** "Science/Tech" has 300K positions (0.2% share). If average contract count is ~160, that's ~1,900 trades. How many markets? How many resolved YES vs NO? The Brier score of 0.1519 could easily be noise.

**Required Fix:** Report:
- Number of resolved markets per category
- Standard errors or confidence intervals for Brier scores
- Minimum sample threshold (e.g., "categories with <10K trades excluded")

---

### 2.7 **Liquidity Threshold: The U-Shape is Suspicious**

**Location:** "Liquidity and Accuracy" section, liquidity table

**Claim:** MAD drops from 5.91% (1-10 trades) to 0.39% (201-1K trades), then rises to 16.32% (100K+ trades)

**Problem:** The rebound at high liquidity is attributed to "presidential election markets" but:
1. The 100K+ bucket has only **4 markets**
2. Claiming these 4 markets prove anything about high-liquidity accuracy is absurd
3. The pattern could easily be: 3 well-calibrated election markets + 1 outlier
4. Paper uses this U-shape to argue "extreme liquidity is not a cure" but the sample is too small

**Cross-check with data:** The liquidity_accuracy.json file confirms: "100K+": 4 markets, MAD 16.32%, Brier 0.1515

**Required Fix:** Either:
1. Exclude buckets with <20 markets from analysis
2. Report individual market statistics for the 4 mega-liquid markets
3. Acknowledge sample size is too small to generalize

---

## 3. MISSING EVIDENCE

### 3.1 **Time-Series Claims Lack Temporal Stratification**

**Claim:** "MAD falls from 5.4% at 30+ days to 1.2% in the final 24 hours"

**Missing:** 
- Does this hold **within individual markets** or only in aggregate?
- Is the 30+ day MAD computed from markets that are currently 30+ days out, or from the 30-day-old prices of markets that later resolved?
- Survival bias: markets that resolve quickly may be systematically different from those that stay open for months

**What's needed:** 
- Within-market time-series showing price → outcome convergence
- Separate analysis of "fast resolvers" vs "slow resolvers"
- Evidence that early prices are genuinely less accurate, not just noisier due to lower volume

---

### 3.2 **Cross-Platform Agreement: Only One Event**

**Claim:** "Correlation of 0.9540" between Kalshi and Polymarket

**Missing:**
- This is computed for ONE event (2024 presidential election)
- No evidence this generalizes to other markets
- Polymarket and Kalshi disagree on legal/settlement terms in many cases
- NBA, weather, finance markets may show different cross-platform behavior

**What's needed:**
- Analysis of 10+ high-volume events across both platforms
- Breakdown by category
- Discussion of when/why platforms diverge

---

### 3.3 **External Forecast Comparison: No Methodology**

**Claim:** "Kalshi's median forecast was 40% more accurate than Bloomberg consensus"

**Missing:**
- What is "median forecast" from a prediction market? The last price? VWAP? Median price over some window?
- How was Bloomberg consensus extracted?
- What time horizon? (Kalshi updates continuously, Bloomberg surveys have 6-week lag)
- Selection bias: did you only include CPI releases where both forecasts existed?

**What's needed:**
- Explicit definition of market-derived forecast
- Timestamp matching methodology
- Full distribution of forecast errors, not just MAE
- Sample size (how many CPI releases?)

---

### 3.4 **No Robustness Checks**

The paper presents point estimates with zero sensitivity analysis:
- What if you exclude the top 1% of markets by volume?
- What if you use 1-cent bins instead of 5-cent bins?
- What if you exclude the 2024 election entirely?
- What if you split pre/post 2024?

**What's needed:** Appendix with at least 3 robustness specifications.

---

## 4. METHODOLOGICAL CONCERNS

### 4.1 **Snapshot vs Trade-Time: Strawman Critique**

**Location:** "Snapshot vs. Trade-Time Methodology" section

**Claim:** "Some platforms report Brier Scores computed from a single price snapshot taken shortly before resolution... This is not forecasting; it is recognizing a fact"

**Problem:** This critique is valid BUT:
1. You never identify WHO uses snapshot methodology
2. No citations of papers/platforms that do this
3. You're implicitly claiming your methodology is superior without comparing to actual alternatives
4. If snapshot methodology is universally bad, why discuss it for 3 paragraphs?

**What's needed:** Either drop this section or cite specific examples of snapshot methodology being used (Polymarket blog? Academic papers?) and compute both methodologies on your data to show the difference.

---

### 4.2 **Trade Positions vs Trades: Undefined**

**Location:** Opening paragraph and throughout

**Problem:** Paper switches between "72.1 million trades" and "135 million trade positions" without defining the relationship.

**From data:** Each trade has a 'count' field (contract count). My sample shows:
- 72.1M trades (confirmed)
- Average 160 contracts per trade
- Estimated 11.5B positions (not 135M!)

**Possible reconciliation:** Maybe "trade position" is defined differently (e.g., only counting taker side? Only counting YES side?). But this is never explained.

**Required Fix:** Define "trade position" explicitly in Data section. Explain why 72.1M trades → 135M positions (if that's even correct).

---

### 4.3 **Category Classification: Keyword-Based is Fragile**

**Location:** analysis_script.py, extract_category() function

**Problem:** Categories assigned by keyword matching:
```python
'politics': ['ELECT', 'PRES', 'SENATE', 'HOUSE', 'IMPEACH']
'sports': ['NFL', 'NBA', 'MLB', 'NHL', 'SOCCER', 'TENNIS', 'GOLF', 'BOWL']
```

**Issues:**
1. What about "PLAYOFF" or "CHAMPIONSHIP"? (could be sports, could be esports)
2. What about "BOWL" in a weather context? (dust bowl, bowl game?)
3. No disambiguation: "TRADE" could be politics (trade war) or finance (trade deficit)
4. No validation: how many markets are classified as "other"?

**From paper:** "World Events" and "Science/Tech" each have <0.3% of trade positions. This suggests most markets ARE being classified, but the keyword lists seem incomplete.

**Required Fix:** 
- Report what % of markets fall into "other"
- Manually audit 100 random "other" markets
- Discuss classification ambiguity

---

### 4.4 **Cost Basis Normalization: Inconsistent with Companion Paper**

**Location:** Methodology section (implicit)

**Problem:** The microstructure paper uses "Cost Basis" normalization: YES at 5 cents = NO at 95 cents both have C_b = 5. This makes sense for return calculations.

BUT: The accuracy paper computes calibration from YES prices only. A trade of NO at 95 cents (which is a 5% bet on NO) would be recorded as:
- YES price = 5
- Should win 5% of the time if it was YES
- But the trader bought NO, which should win 95% of the time

**Are you correctly inverting NO trades?** The paper never discusses this. If you're naively using yes_price for all trades regardless of taker_side, your calibration is garbage.

**Required Fix:** Explicitly state how NO-side trades are handled in calibration calculations.

---

## 5. CITATIONS TO VERIFY

### 5.1 **Verified and Legitimate**
- Brier (1950) ✓
- Murphy (1973) ✓  
- Diercks et al. (2026) ✓ (but "perfect accuracy" claim not in abstract)
- Fama (1970) ✓
- Griffith (1949) ✓
- Hayek (1945) ✓
- Standard textbook citations appear legitimate

### 5.2 **Cannot Verify (Possibly Fabricated)**
- Angelini & De Angelis (2026) - NO SEARCH RESULTS
- Le (2026) arXiv:2601.12345 - NO SEARCH RESULTS

### 5.3 **Verify But Suspicious**
- "Recent Fed research" → Diercks et al.: Claim of "perfect accuracy" not in abstract
- "companion paper" → Exists, but claims about maker-taker gap (0.17pp in finance, 4.79pp in entertainment) need to be cross-checked against that paper's actual data

---

## 6. SPECIFIC RECOMMENDATIONS FOR FIXES

### Immediate (Blocking Publication)

1. **Verify or retract the 50.00% claim**
   - Run the actual calculation on the full dataset
   - If it's true, show the code that computes it
   - If it's false, revise to "approximately 50%" and report actual number

2. **Remove phantom citations**
   - Angelini & De Angelis: either produce the paper or remove citation
   - Le (2026): either produce the paper or remove citation

3. **Define "trade position" vs "trade"**
   - 72.1M → 135M conversion needs an explicit formula

4. **Fix Murphy decomposition explanation**
   - Clarify whether you're treating each trade as one or two forecasts
   - Justify the "YES perspective" choice

### High Priority (Before SSRN Submission)

5. **Add confidence intervals to category table**
   - Bootstrap SEs for Brier scores
   - Report market counts, not just position counts

6. **Provide external forecast comparison details**
   - Methodology for "Kalshi's median forecast"
   - Sample sizes
   - Verification of "perfect accuracy" claim from Diercks source

7. **Drop or fix the liquidity analysis above 25K trades**
   - N=4 is not generalizable
   - Either get more high-liquidity markets or acknowledge limitation

8. **Temporal analysis stratification**
   - Show that time-to-resolution accuracy holds WITHIN markets
   - Address survival bias

### Medium Priority (Strengthens Paper)

9. **Cross-platform analysis expansion**
   - More than one event
   - Category breakdown
   - Formal test of information equilibrium

10. **Robustness checks appendix**
    - Exclude 2024 election
    - Different bin widths
    - Subsample by time period

11. **Snapshot methodology comparison**
    - Compute both methodologies on your data
    - Show the magnitude of difference
    - Or drop the section entirely

## 7. QUESTIONS FOR THE AUTHOR

1. How exactly did you compute the "50.00%" figure? My replication shows 46.21%. Is there a time-window filter? A minimum liquidity threshold?

2. Do the Angelini and Le papers exist? If so, can you share preprints?

3. Where in Diercks et al. is the "perfect accuracy" claim? I see the abstract mentions "high-frequency" and "distributionally rich" but not perfect forecasting.

4. Why does the analysis script not contain code to generate the key statistics in the paper (50.00%, 135M positions, etc.)?

5. How do you handle NO-side trades in calibration? Are you inverting prices correctly?

6. What is a "trade position"? Is it:
   - One contract in a trade (72.1M trades × 160 avg = 11.5B positions)?
   - One side of a trade (72.1M × 2 = 144M)?
   - Something else (which gets you to 135M)?

7. The "accuracy paradox" explanation seems circular. What independent evidence suggests questions got harder, aside from the Brier score itself?

---

## 8. OVERALL ASSESSMENT

This paper has significant merit in its framing and ambition:
- Important question (do prediction markets actually work?)
- Large-scale data (72M trades, 51GB)
- Sophisticated decomposition (Murphy)
- Direct comparison to external benchmarks (Fed surveys)

BUT the execution has serious problems:

**Fatal flaws:**
- Headline claim (50.00%) is not substantiated and likely false
- Phantom citations undermine credibility
- Murphy decomposition methodology is ambiguous/incorrect
- "Perfect accuracy" claim cannot be verified from cited source

**Major weaknesses:**
- No confidence intervals despite small category samples
- Cross-platform analysis is one event only
- External forecast methodology is opaque
- Time-series analysis doesn't address survival bias
- Liquidity analysis over-interprets N=4 subsample

**Minor issues:**
- Category classification is fragile
- Trade position definition is unclear
- Snapshot methodology critique lacks citations
- Robustness checks are absent

**Verdict:** This paper should NOT be published in its current form. The central empirical claim cannot be replicated from the provided code and data. Either:
1. Provide the methodology that produces "50.00%" and make it reproducible
2. Revise claims to match what the data actually shows (which may be "49-51% depending on time period")

If the 50% claim is wrong, the entire framing collapses. "Prediction markets are approximately accurate, within 3-4 percentage points" is a much weaker claim.

The phantom citations and unverified "perfect accuracy" claim suggest the paper was written in haste, possibly with aspirational citations to papers that don't exist yet or claims that were misremembered from sources.

**Recommended action:** Major revision required. Do not submit to SSRN until fatal flaws are fixed.

---

## 9. POSITIVE NOTES (What's Good)

Despite the issues above, several aspects are strong:

1. **Murphy decomposition insight**: The idea that Sports has high Brier due to irreducible uncertainty (not miscalibration) is genuinely insightful, IF the numbers are right.

2. **Compositional explanation**: The "accuracy paradox" (rising Brier + falling MAD) is a real phenomenon and the volume composition explanation is plausible.

3. **Data scale**: 72M trades across 7.68M markets is impressive. Few papers have analyzed prediction markets at this scale.

4. **Liquidity threshold finding**: The 200-trade threshold for reliable prices is actionable advice for users.

5. **Writing quality**: The prose is clear and engaging. The framing (slot machines → prediction markets) is memorable.

If the empirical issues are resolved, this could be a strong paper.

---

**END OF REVIEW**

# The Longshot Bias in Prediction Markets

![preview](https://raw.githubusercontent.com/Jon-Becker/research/main/papers/longshot-bias-prediction-markets/preview.svg?fw)

The efficient market hypothesis (EMH) posits that asset prices fully reflect all available information. In the context of prediction markets—where participants trade contracts paying out based on future events—this implies that a contract trading at 30 cents should win exactly 30% of the time. If it doesn't, observing traders should arbitrage the discrepancy until the price aligns with reality.

Yet, decades of behavioral finance research have documented a persistent anomaly known as the **longshot bias**: the tendency for low-probability events to be overpriced. Bettors love longshots. Whether in horse racing, lotteries, or options markets, people systematically overpay for the slim chance of a massive payout.

We collected and analyzed a dataset of **67.8 million trades** from the CFTC-regulated prediction market Kalshi, covering over $8 billion in trading volume. The data reveals that prediction markets are not immune to this bias. In fact, they exhibit specific, quantifiable inefficiencies that sophisticated traders can—and do—exploit.

## The Longshot Bias

Our primary finding is arguably the most robust example of the longshot bias ever documented. When we compare the market price of a contract at the time of a trade to its ultimate resolution, a clear pattern emerges: contracts priced low win far less often than they should.

Specifically, contracts priced at **5 cents** (implying a 5% probability) resolve favorably only **3.5%** of the time. This might sound like a small difference, but in percentage terms, it represents a massive 30% relative overpricing. If you systematically bought these longshots, you would expect to lose nearly a third of your capital.

![Calibration Curve](https://raw.githubusercontent.com/Jon-Becker/research/main/papers/longshot-bias-prediction-markets/1.svg?fw)

The calibration curve above shows this deviation. The dashed line represents perfect calibration. The solid blue line tracks our empirical data. At the left tail (low prices), the blue line dips significantly below the dashed line. This confirms that these "cheap" options are actually expensive in expected value terms.

Interestingly, this bias is not symmetric. High-priced favorites (e.g., contracts trading at 95 cents) actually exhibit a slight *reverse* bias, winning slightly more often than their prices imply. This S-shaped deviation aligns perfectly with the probability weighting functions described in Prospect Theory, suggesting that human behavioral biases—specifically the over-weighting of small probabilities—drive market prices even in regulated financial environments.

## Who is Losing Money?

If longshots are overpriced, someone must be buying them. And if they are consistently losing money, someone else must be making it. By segmenting our data by trade size, we found a stark divergence in performance.

Small trades are consistently unprofitable. Trades under $100 generate negative excess returns of approximately -1.3% on average. This suggests that the "marginal" trader driving the longshot bias is likely a retail participant placing small, speculative bets.

![Trade Size Returns](https://raw.githubusercontent.com/Jon-Becker/research/main/papers/longshot-bias-prediction-markets/2.svg?fw)

On the other end of the spectrum, large trades tell a different story. Trades exceeding **$5,000** achieve positive excess returns. These "whale" trades are not just lucky; they are systematically smarter. The data implies that sophisticated actors are identifying mispriced contracts—likely the overpriced longshots bid up by retail traders—and taking the other side.

This size-based heterogeneity provides a mechanism for how the market stays somewhat tethered to reality. While retail flow creates noise and bias, institutional capital acts as a partial corrective force, though evidently not enough to completely eliminate the inefficiency.

## Market Dynamics & Liquidity

Price formation isn't just about beliefs; it's about the mechanics of trading. We examined how bid-ask spreads evolve across the probability spectrum to understand the cost of providing liquidity.

Standard microstructure theory suggests that spreads should be widest where asymmetric information is highest—typically at the extremes. However, we observe an **inverted U-shape** pattern.

![Bid-Ask Spreads](https://raw.githubusercontent.com/Jon-Becker/research/main/papers/longshot-bias-prediction-markets/3.svg?fw)

The spread is tightest at the extremes (near 0 and 100 cents) and widest in the middle (around 50 cents). This likely reflects inventory risk rather than information symmetry. A contract trading at 50 cents has the maximum possible variance ($\sigma^2 = p(1-p)$), exposing market makers to the greatest volatility. To compensate for this risk, they widen their spreads.

## Temporal Convergence

Finally, we looked at how "correct" the market is as a function of time. Unsurprisingly, prediction markets become more accurate as the event approaches. The excess win rate (a measure of error) improves from -1.8% for trades placed a week out to -0.4% in the final hour.

However, we found that **market reactions are asymmetric**. Traders exhibit a "contrarian advantage." Strategies that bought contracts after their price had dropped significantly (>10%) outperformed, while "momentum" strategies that chased rising prices underperformed. This suggests that prediction markets, like equity markets, are prone to overreaction.

## Conclusion

Prediction markets are powerful forecasting tools, but they are not crystal balls. They are markets, populated by humans (and algorithms written by humans) subject to classic behavioral biases.

For the casual observer, the lesson is caution: that 5-cent "lottery ticket" is likely worth closer to 3 cents. For the sophisticated trader, the lesson is opportunity: the bias is persistent, predictable, and—with enough capital—exploitable. Use the market's probabilities, but treat them as a raw signal in need of calibration, especially when the odds look long.

---

### Resources & Citations

- Arrow, K. J., et al. "The Promise of Prediction Markets." *Science* 320.5878 (2008): 877-878.
- Kahneman, D., & Tversky, A. "Prospect theory: An analysis of decision under risk." *Econometrica* 47.2 (1979): 263-291.
- Prelec, D. "The probability weighting function." *Econometrica* 66.3 (1998): 497-527.
- Wolfers, J., & Zitzewitz, E. "Prediction markets." *Journal of Economic Perspectives* 18.2 (2004): 107-126.
- Snowberg, E., & Wolfers, J. "Explaining the favorite–long shot bias: Is it risk-love or misperceptions?" *Journal of Political Economy* 118.4 (2010): 723-746.

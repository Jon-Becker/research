# Inside the Mind of the Prediction Market Trader

![preview](https://raw.githubusercontent.com/Jon-Becker/research/main/papers/longshot-bias-prediction-markets/preview.png?fw)

The efficient market hypothesis is a beautiful idea. It suggests that asset prices are the perfect aggregation of all available information—rational, unbiased, and notoriously hard to beat.

But markets aren't made of math; they're made of people. And people love a longshot.

We analyzed **72.1 million trades** on Kalshi, a CFTC-regulated prediction market, covering over **$18 billion** in trading volume. What we found wasn't a pristine machine of collective intelligence. Instead, we found a market deeply shaped by human psychology—risk-seeking, overreaction, and the eternal hope that *this* lottery ticket is the one that pays off.

Here is what 72 million trades tell us about who we are when money is on the line.

## The Longshot Bias

The most pervasive anomaly in our data is the **longshot bias**. In a perfectly efficient market, a contract trading at 5 cents (implying a 5% probability) should win exactly 5% of the time.

In reality, cheap contracts are terrible bets.

![Win Rate Calibration](https://raw.githubusercontent.com/Jon-Becker/research/main/papers/longshot-bias-prediction-markets/win_rate_by_price.png?fw)

As the chart above shows, contracts priced at 5 cents resolve favorably only **3.5%** of the time. That gap might look small, but it represents a **30% loss** on investment. If you systematically bought every "cheap" contract on the platform, you would essentially be lighting money on fire.

Conversely, "safe" bets are slightly underpriced. Contracts above 95 cents win more often than their prices imply. This S-shaped curve perfectly matches the *probability weighting function* from Prospect Theory: humans systematically overweight small probabilities (buying hope) and underweight large ones (fearing certainty).

## Smart Money vs. Dumb Money

If longshots are consistently overpriced, who is buying them? And who is getting rich selling them?

The answer lies in trade size. When we break down performance by the size of the bet, a stark "Smart Money vs. Dumb Money" dynamic emerges.

![Trade Size vs Win Rate](https://raw.githubusercontent.com/Jon-Becker/research/main/papers/longshot-bias-prediction-markets/trade_size_vs_win_rate.png?fw)

*   **Small trades (<$100)** are consistently unprofitable. These are likely retail traders chasing lottery tickets, systematically overpaying for volatility.
*   **Whale trades (>$5,000)** generate positive excess returns. These large, sophisticated actors aren't gambling; they are acting as the casino, taking the other side of retail's bad bets.

This suggests the market isn't just biased—it's predatory. Sophisticated traders are effectively collecting a "behavioral tax" from retail participants.

## Trading in Your Sleep

One of the most surprising findings is that *when* you trade matters just as much as *what* you trade.

We broke down calibration and volume by hour of day (Eastern Time), and the difference between the "night shift" and the "day shift" is dramatic.

![Intraday Patterns](https://raw.githubusercontent.com/Jon-Becker/research/main/papers/longshot-bias-prediction-markets/intraday_weekday_patterns.png?fw)

*   **The Graveyard Shift (2 AM - 5 AM):** Calibration falls off a cliff. Returns are at their worst (-2.3% excess return). Liquidity is thin, institutional desks are closed, and the market is dominated by insomniacs and bots engaging in noise trading.
*   **The Morning Rush (8 AM - 10 AM):** The professionals clock in. Calibration is tightest (-0.7% excess return). If you want fair odds, trade when Wall Street is awake.
*   **The Evening Surge:** Volume actually peaks in the evening (after 6 PM), but efficiency doesn't match the volume. This is the retail "second shift"—people getting home from work and logging on to trade the news.

## Chasing the Action

Traders don't just trade based on probabilities; they trade based on *price action*. We found strong evidence of **momentum overreaction**.

![Contrarian vs Momentum](https://raw.githubusercontent.com/Jon-Becker/research/main/papers/longshot-bias-prediction-markets/contrarian_vs_momentum.png?fw)

*   **Momentum Chasers:** Traders who bought contracts after the price had just spiked (>10% increase) did terribly, suffering -5.4% excess returns. They bought the hype at the top.
*   **The Contrarian Edge:** Traders who bought after a crash avoided this trap. They didn't necessarily get rich, but they lost far less than the momentum crowd.

This pattern—chasing green candles and panic-selling red ones—is the hallmark of inexperienced trading, amplified here by the binary nature of the contracts.

## What Are We Betting On?

Finally, it's worth noting where the money actually goes. While prediction markets are touted for forecasting elections and climate risks, the volume distribution tells a simpler story.

![Volume by Price](https://raw.githubusercontent.com/Jon-Becker/research/main/papers/longshot-bias-prediction-markets/total_volume_by_price.png?fw)

Volume isn't distributed evenly. It clusters massively at the extremes—particularly at 99 cents. Paradoxically, the highest dollar volume is on "sure things," while the highest *number of contracts* traded is often on penny-priced longshots. We are simultaneously obsessed with safety (parking cash in near-certain yields) and danger (buying cheap lottery tickets). The middle ground—genuine uncertainty—is where liquidity often goes to die.

## Conclusion

Prediction markets are often described as "truth machines." A more accurate description might be "consensus machines." They reflect our collective intelligence, yes, but also our collective biases, our sleep schedules, and our tendency to overreact to the latest headline.

For the aspiring trader, the lesson is clear:
1.  **Don't be a hero.** Avoid the 5-cent longshots.
2.  **Size indicates conviction.** Trust the whales, fade the minnows.
3.  **Sleep at night.** Nothing good happens in the market at 3 AM.

---

### Resources & Citations

- Kahneman, D., & Tversky, A. "Prospect theory: An analysis of decision under risk." *Econometrica* 47.2 (1979): 263-291.
- Snowberg, E., & Wolfers, J. "Explaining the favorite–long shot bias: Is it risk-love or misperceptions?" *Journal of Political Economy* 118.4 (2010): 723-746.
- Prelec, D. "The probability weighting function." *Econometrica* 66.3 (1998): 497-527.
- Kyle, A. S. "Continuous auctions and insider trading." *Econometrica* 53.6 (1985): 1315-1335.

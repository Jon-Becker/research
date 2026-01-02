# Inside the Mind of the Prediction Market Trader

![preview](https://raw.githubusercontent.com/Jon-Becker/research/main/papers/longshot-bias-prediction-markets/preview.png?fw)

The efficient market hypothesis is a beautiful idea. It suggests that asset prices are the perfect aggregation of all available information—rational, unbiased, and notoriously hard to beat.

But markets aren't made of math; they're made of people. And people love a longshot.

We analyzed **72.1 million trades** on Kalshi, a CFTC-regulated prediction market, covering over **$18 billion** in trading volume. What we found wasn't a pristine machine of collective intelligence. Instead, we found a market deeply shaped by human psychology—risk-seeking, overreaction, and the eternal hope that *this* lottery ticket is the one that pays off.

![Kalshi Volume Growth](https://raw.githubusercontent.com/Jon-Becker/research/main/papers/longshot-bias-prediction-markets/volume_over_time.png?fw)

Kalshi's growth has been explosive—from $3.4 million in quarterly volume in 2021 to nearly $8.8 billion by late 2025. This dataset captures a market in its formative years, revealing the behavioral patterns that emerge when real money meets probabilistic thinking.

Here is what 72 million trades tell us about who we are when money is on the line.

## The Longshot Bias

The most pervasive anomaly in our data is the **longshot bias**. In a perfectly efficient market, a contract trading at 5 cents (implying a 5% probability) should win exactly 5% of the time.

In reality, cheap contracts are terrible bets.

![Win Rate Calibration](https://raw.githubusercontent.com/Jon-Becker/research/main/papers/longshot-bias-prediction-markets/win_rate_by_price.png?fw)

As the chart above shows, contracts priced at 5 cents resolve favorably only **3.5%** of the time. That gap might look small, but it represents a **30% loss** on investment. If you systematically bought every "cheap" contract on the platform, you would essentially be lighting money on fire.

Conversely, "safe" bets are slightly underpriced. Contracts above 95 cents win more often than their prices imply. This S-shaped curve perfectly matches the *probability weighting function* from Prospect Theory: humans systematically overweight small probabilities (buying hope) and underweight large ones (fearing certainty).

### The Scale of Mispricing

Just how severe is this mispricing? The chart below shows the magnitude of calibration error across all price levels:

![Mispricing by Price](https://raw.githubusercontent.com/Jon-Becker/research/main/papers/longshot-bias-prediction-markets/mispricing_by_price.png?fw)

Contracts at 1-5 cents are mispriced by **30-55%** relative to their implied probability. A 2-cent contract that should win 2% of the time actually wins closer to 0.9% of the time. The mispricing is not symmetric—longshots are dramatically overpriced, while favorites are only slightly underpriced.

## The Lottery Ticket Effect

The longshot bias isn't just about mispricing—it's about *behavior*. Traders treat cheap contracts like lottery tickets, buying them in bulk.

![Trade Count by Price](https://raw.githubusercontent.com/Jon-Becker/research/main/papers/longshot-bias-prediction-markets/trades_by_price.png?fw)

The distribution of trades by price tells a striking story. There's a massive spike at 1-2 cents—traders flooding into penny contracts hoping for a moonshot. Trading activity is also elevated around 50 cents (maximum uncertainty) and spikes again at 99 cents (near-certainties).

![Contracts per Trade](https://raw.githubusercontent.com/Jon-Becker/research/main/papers/longshot-bias-prediction-markets/avg_contracts_by_price.png?fw)

When traders do buy longshots, they buy *a lot* of them. At 1 cent, the average trade contains **1,400 contracts**—nearly 7x more than trades at mid-range prices. This is pure lottery ticket behavior: "It's only a penny, might as well buy a thousand." The asymmetric payoff structure ($1 return on a $0.01 investment) triggers the same psychology that drives Powerball sales.

## Not All Markets Are Equal

One of our most important findings is that **mispricing varies dramatically by market category**:

![Mispricing by Category](https://raw.githubusercontent.com/Jon-Becker/research/main/papers/longshot-bias-prediction-markets/mispricing_by_category.png?fw)

*   **Sports & Crypto:** Wild mispricing at the extremes. Sports longshots can be mispriced by 50-100%+ at very low prices. These categories attract the most speculative, entertainment-driven trading.
*   **Politics & Finance:** More calibrated across the board. These categories attract traders who are genuinely trying to forecast outcomes, not just gamble.
*   **Weather & Science:** Too little volume for reliable conclusions, but generally show moderate calibration.

The lesson is clear: if you're looking for market efficiency, stick to politics and finance. If you're looking to exploit behavioral biases, the sports and crypto markets are where the "dumb money" plays.

## Smart Money vs. Dumb Money

If longshots are consistently overpriced, who is buying them? And who is getting rich selling them?

The answer lies in trade size. When we break down performance by the size of the bet, a stark "Smart Money vs. Dumb Money" dynamic emerges.

![Trade Size vs Win Rate](https://raw.githubusercontent.com/Jon-Becker/research/main/papers/longshot-bias-prediction-markets/trade_size_vs_win_rate.png?fw)

*   **Small trades (<$100)** are consistently unprofitable. These are likely retail traders chasing lottery tickets, systematically overpaying for volatility.
*   **Whale trades (>$5,000)** generate positive excess returns. These large, sophisticated actors aren't gambling; they are acting as the casino, taking the other side of retail's bad bets.

This suggests the market isn't just biased—it's predatory. Sophisticated traders are effectively collecting a "behavioral tax" from retail participants.

## Market Duration Effects

How long a market stays open significantly impacts its efficiency:

![Market Duration Effects](https://raw.githubusercontent.com/Jon-Becker/research/main/papers/longshot-bias-prediction-markets/market_duration_effects.png?fw)

*   **Short-duration markets (1-4 hours):** Lower accuracy but smaller average trade sizes (~$60). These fast-expiring markets attract quick, speculative bets.
*   **Long-duration markets (>4 weeks):** Best calibration and largest trade sizes (~$175). Longer time horizons attract more sophisticated capital willing to tie up funds for better odds.
*   **Most activity:** Concentrates in 1-3 day markets, where there's enough time to react to news but not so much that capital is locked up indefinitely.

## When You Trade Matters

One of the most surprising findings is that *when* you trade matters just as much as *what* you trade.

### Trading Volume by Hour

Activity on the platform follows a predictable daily rhythm:

![Trading Volume by Hour](https://raw.githubusercontent.com/Jon-Becker/research/main/papers/longshot-bias-prediction-markets/trading_volume_by_hour.png?fw)

Volume peaks in the evening hours (6-10 PM ET) when retail traders log on after work. The overnight hours (2-5 AM) see minimal activity.

### Market Efficiency by Hour

But here's the critical insight—the market's efficiency varies dramatically by time of day:

![Market Efficiency by Hour](https://raw.githubusercontent.com/Jon-Becker/research/main/papers/longshot-bias-prediction-markets/market_efficiency_by_hour.png?fw)

*   **The Graveyard Shift (2 AM - 5 AM):** Calibration falls off a cliff. Returns are at their worst (-2.3% excess return). Liquidity is thin, institutional desks are closed, and the market is dominated by insomniacs and bots engaging in noise trading.
*   **The Morning Rush (8 AM - 10 AM):** The professionals clock in. Calibration is tightest (-0.7% excess return). If you want fair odds, trade when Wall Street is awake.
*   **The Evening Surge:** Volume peaks but efficiency doesn't. This is the retail "second shift"—people getting home from work and trading emotionally.

### Trade Size by Hour

Who's trading when? The average trade size tells the story:

![Trade Size by Hour](https://raw.githubusercontent.com/Jon-Becker/research/main/papers/longshot-bias-prediction-markets/trade_size_by_hour.png?fw)

Larger, presumably more sophisticated trades cluster during business hours. Evening and overnight trading skews toward smaller retail positions.

### Day of Week Effects

The weekday patterns tell a similar story:

![Trading Volume by Day](https://raw.githubusercontent.com/Jon-Becker/research/main/papers/longshot-bias-prediction-markets/trading_volume_by_day.png?fw)

![Market Efficiency by Day](https://raw.githubusercontent.com/Jon-Becker/research/main/papers/longshot-bias-prediction-markets/market_efficiency_by_day.png?fw)

Weekend trading (highlighted in red) shows both higher volume (likely sports betting) and worse calibration. The market is less efficient when the professionals are away.

![Weekend vs Weekday Accuracy](https://raw.githubusercontent.com/Jon-Becker/research/main/papers/longshot-bias-prediction-markets/weekend_vs_weekday_accuracy.png?fw)

## Chasing the Action

Traders don't just trade based on probabilities; they trade based on *price action*. We found strong evidence of **momentum overreaction**.

![Returns by Price Movement](https://raw.githubusercontent.com/Jon-Becker/research/main/papers/longshot-bias-prediction-markets/returns_by_price_movement.png?fw)

*   **Momentum Chasers:** Traders who bought contracts after the price had just spiked (>10% increase) did terribly, suffering -5.4% excess returns. They bought the hype at the top.
*   **The Contrarian Edge:** Traders who bought after a crash avoided this trap. They didn't necessarily get rich, but they lost far less than the momentum crowd.

![Contrarian vs Momentum Strategies](https://raw.githubusercontent.com/Jon-Becker/research/main/papers/longshot-bias-prediction-markets/contrarian_vs_momentum_strategies.png?fw)

This pattern—chasing green candles and panic-selling red ones—is the hallmark of inexperienced trading, amplified here by the binary nature of the contracts.

## The Last-Minute Rush

When does most trading actually happen? The answer is striking:

![Volume Acceleration](https://raw.githubusercontent.com/Jon-Becker/research/main/papers/longshot-bias-prediction-markets/volume_acceleration.png?fw)

Over **60% of all volume** occurs in the final 10% of a market's lifetime. Traders wait until the last possible moment, when uncertainty is at its lowest (and alpha opportunities are scarce). This suggests most participants are not forecasting—they're reacting to news that's already priced in.

## Early Birds and Late Arrivals

Does it pay to be early? We analyzed trader returns based on when they entered a market relative to its total lifetime:

![Early vs Late Trader Returns](https://raw.githubusercontent.com/Jon-Becker/research/main/papers/longshot-bias-prediction-markets/early_vs_late_trader_returns.png?fw)

Early traders (entering in the first 10-20% of a market's life) show *more variance* in returns but no consistent edge. Late traders pile in when the outcome is nearly certain, leaving little room for profit. The relationship between entry timing and returns shows a weak positive slope of 0.29pp per 100% of market lifetime.

## Price Convergence

How quickly do markets converge to the correct price? Our analysis of price accuracy vs. time to resolution shows:

![Price Convergence to Resolution](https://raw.githubusercontent.com/Jon-Becker/research/main/papers/longshot-bias-prediction-markets/price_convergence_to_resolution.png?fw)

Interestingly, markets with very long time horizons (>4 weeks) actually show better calibration than medium-term markets. The worst calibration occurs 1-7 days before resolution—perhaps when news flow is most intense and emotional trading peaks.

## Round Number Psychology

Humans love round numbers, and prediction markets are no exception:

![Round Number Clustering](https://raw.githubusercontent.com/Jon-Becker/research/main/papers/longshot-bias-prediction-markets/round_number_clustering.png?fw)

Trades cluster significantly at "key round" prices (10, 25, 50, 75, 90 cents) and especially at extreme prices (1-3 and 97-99 cents). This clustering is statistically significant (χ²=401,343, p<0.001) and suggests traders anchor on psychologically salient price points rather than calculating precise fair values.

## Liquidity and Spreads

Market microstructure matters. Bid-ask spreads vary dramatically across price levels:

![Bid-Ask Spread Dynamics](https://raw.githubusercontent.com/Jon-Becker/research/main/papers/longshot-bias-prediction-markets/bid_ask_spread_dynamics.png?fw)

Spreads are widest at 50 cents—maximum uncertainty—and narrowest at the extremes. Higher volume correlates strongly with tighter spreads (ρ=-0.99), and wider spreads correlate perfectly with worse price accuracy (ρ=1.00). Illiquid markets are inefficient markets.

## What Are We Betting On?

Finally, it's worth noting where the money actually goes. While prediction markets are touted for forecasting elections and climate risks, the volume distribution tells a simpler story.

![Market Types by Volume](https://raw.githubusercontent.com/Jon-Becker/research/main/papers/longshot-bias-prediction-markets/market_types.png?fw)

**Sports** dominates with over $12.6 billion in volume across 3.6 million markets. Politics ($2.4B), Crypto ($836M), and Finance ($700M) are distant seconds. The "serious" forecasting use cases—weather, science, economics—are rounding errors in the total volume.

![Volume by Price](https://raw.githubusercontent.com/Jon-Becker/research/main/papers/longshot-bias-prediction-markets/total_volume_by_price.png?fw)

Volume isn't distributed evenly across price levels. It clusters massively at the extremes—particularly at 99 cents. Paradoxically, the highest dollar volume is on "sure things," while the highest *number of contracts* traded is often on penny-priced longshots. We are simultaneously obsessed with safety (parking cash in near-certain yields) and danger (buying cheap lottery tickets). The middle ground—genuine uncertainty—is where liquidity often goes to die.

## Conclusion

Prediction markets are often described as "truth machines." A more accurate description might be "consensus machines." They reflect our collective intelligence, yes, but also our collective biases, our sleep schedules, and our tendency to overreact to the latest headline.

For the aspiring trader, the lessons are clear:

1.  **Don't be a hero.** Avoid the 5-cent longshots—they're systematically overpriced.
2.  **Size indicates conviction.** Trust the whales, fade the minnows.
3.  **Sleep at night.** Nothing good happens in the market at 3 AM.
4.  **Don't chase momentum.** The crowd has already moved—you're buying the top.
5.  **Trade during business hours.** That's when the smart money is active.
6.  **Avoid illiquid markets.** Wide spreads mean worse prices.
7.  **Pick your category.** Sports and crypto are entertainment; politics and finance are where efficiency lives.

---

### Resources & Citations

- Kahneman, D., & Tversky, A. "Prospect theory: An analysis of decision under risk." *Econometrica* 47.2 (1979): 263-291.
- Snowberg, E., & Wolfers, J. "Explaining the favorite–long shot bias: Is it risk-love or misperceptions?" *Journal of Political Economy* 118.4 (2010): 723-746.
- Prelec, D. "The probability weighting function." *Econometrica* 66.3 (1998): 497-527.
- Kyle, A. S. "Continuous auctions and insider trading." *Econometrica* 53.6 (1985): 1315-1335.

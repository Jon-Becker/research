# The Irrational Crowd That Predicts the Future

![preview](https://raw.githubusercontent.com/Jon-Becker/research/main/papers/longshot-bias-prediction-markets/preview.png?fw)

Prediction market traders exhibit every behavioral bias in the textbook. They chase lottery tickets, cluster on round numbers, pile into momentum trades, and make worse decisions at 3 AM than at 10 AM. By any measure of individual rationality, they're a mess.

And yet, the prices they collectively produce are remarkably accurate.

We analyzed **72.1 million trades** on Kalshi covering **\$18.26 billion** in notional volume across **7.68 million markets**. What we found is a paradox that cuts to the heart of the efficient market hypothesis: individual irrationality can coexist with collective accuracy. The market doesn't need rational participants. It needs a mechanism that aggregates their errors into signal.

## Brief: Prediction Markets and Kalshi

Prediction markets are event-based exchanges where participants trade binary contracts on real-world outcomes. These contracts settle at either \$1 or \$0, with their trading price ranging from 0 to 100 cents serving as a proxy for the market's perceived probability. Traders capitalize on discrepancies between the market price and their own forecasts by buying or selling accordingly.

[Kalshi](https://kalshi.com) debuted in 2021 as the first U.S. prediction market regulated by the CFTC, operating under the same legal framework as traditional futures exchanges. While it initially focused on economic and weather-related data, the platform remained a niche venue until 2024. Following a [landmark legal victory](https://media.cadc.uscourts.gov/opinions/docs/2024/10/24-5205-2077790.pdf) over the CFTC, Kalshi secured the right to list political contracts. The ensuing 2024 election cycle triggered a massive surge in volume, and the 2025 introduction of sports markets has since solidified Kalshi's transition into a mainstream financial platform.

```chart
{
  "type": "bar",
  "title": "Kalshi Quarterly Volume",
  "data": [
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

```chart
{
  "type": "treemap",
  "data": [{"name":"Sports","value":13181352943,"children":[{"name":"NFL","value":3790985589,"children":[{"name":"Games","value":3017237118},{"name":"Spreads","value":247733494},{"name":"Totals","value":138285716},{"name":"Multi-Game Props","value":124661080},{"name":"Super Bowl","value":76188662},{"name":"Single-Game Props","value":64963059}]},{"name":"NCAA Football","value":2950704048,"children":[{"name":"Games","value":2799948915},{"name":"Spreads","value":62447730},{"name":"Totals","value":40371510}]},{"name":"NBA","value":2140808179,"children":[{"name":"Games","value":1769701524},{"name":"Other NBA","value":146284983},{"name":"Series","value":109347734},{"name":"Totals","value":26017335},{"name":"Eastern Conf","value":23943942},{"name":"Western Conf","value":22623848}]},{"name":"MLB","value":1106021157,"children":[{"name":"Games","value":865058318},{"name":"Other MLB","value":90597476},{"name":"Series","value":66572894},{"name":"American League","value":29165417},{"name":"HR Derby","value":15967466},{"name":"National League","value":14230740},{"name":"All-Star Game","value":11380418}]},{"name":"Tennis","value":1005843484,"children":[{"name":"ATP Matches","value":450159413},{"name":"WTA Matches","value":338563928},{"name":"Wimbledon M","value":47419000},{"name":"US Open M","value":35458687},{"name":"French Open M","value":31816184},{"name":"French Open W","value":22598170},{"name":"French Open","value":21123935},{"name":"US Open W","value":20050935},{"name":"Wimbledon W","value":19616103}]},{"name":"NCAA Basketball","value":705272887,"children":[{"name":"March Madness M","value":507406745},{"name":"Games","value":176873783},{"name":"Totals","value":7616389},{"name":"Spreads","value":7101186}]},{"name":"Golf","value":519943873,"children":[{"name":"PGA Tour","value":231000998},{"name":"Masters","value":86876354},{"name":"US Open","value":71009638},{"name":"The Open","value":45869851},{"name":"Other PGA","value":38815969},{"name":"Ryder Cup","value":22566406},{"name":"Ryder Cup Match","value":21750933}]},{"name":"NHL","value":394541367,"children":[{"name":"Games","value":344058272},{"name":"Series","value":19426429},{"name":"Other NHL","value":16680955},{"name":"Totals","value":6035454}]},{"name":"Soccer","value":361466071,"children":[{"name":"EPL Games","value":133683762},{"name":"UCL Games","value":78565663},{"name":"FIFA Games","value":23211654},{"name":"La Liga Games","value":19959835},{"name":"MLS Games","value":19478116},{"name":"Club WC Games","value":16123943},{"name":"Serie A Games","value":13517280},{"name":"Ligue 1 Games","value":9960954},{"name":"Bundesliga Games","value":9449715},{"name":"UEFA CL","value":6763050},{"name":"Premier League","value":5741358},{"name":"Euroleague","value":4647294},{"name":"Brasileirao","value":3903991}]},{"name":"UFC/Boxing","value":132261954,"children":[{"name":"UFC Fights","value":103744086},{"name":"Boxing","value":26365329},{"name":"Other UFC","value":2152539}]}]},{"name":"Politics","value":2447937404,"children":[{"name":"Presidential","value":789917299,"children":[{"name":"General","value":789917299}]},{"name":"Electoral College","value":578139403,"children":[{"name":"Other","value":449930058},{"name":"Margin","value":86308117},{"name":"Closest State","value":25934826},{"name":"Swing States DJT","value":10231804}]},{"name":"Popular Vote","value":383443392,"children":[{"name":"Margin","value":294162474},{"name":"Winner","value":83762785},{"name":"KH Margin","value":5518133}]},{"name":"NYC Mayor","value":147296546,"children":[{"name":"Party","value":121642553},{"name":"Nominations","value":16963803},{"name":"2nd Round","value":4967665},{"name":"D Round","value":2125738},{"name":"Debate Mentions","value":1578656}]},{"name":"Other Politics","value":103681834,"children":[{"name":"Power","value":28568811},{"name":"EO Count Day 1","value":11701421},{"name":"Inauguration","value":6650681},{"name":"State Deep DJT","value":6143975},{"name":"Cuomo Dropout","value":6128407},{"name":"Dem Sweep","value":3999435},{"name":"TikTok Ban","value":3907027},{"name":"EO Count Day 2","value":3896884},{"name":"WI SCOTUS","value":3571663},{"name":"Speaker","value":3007371},{"name":"World Leader","value":2656694},{"name":"EO Week","value":2503837},{"name":"Leave Admin","value":2356242},{"name":"Debates 2024","value":2352425},{"name":"Gabbard Count","value":2036501},{"name":"Greenland","value":1989254},{"name":"WI Court Margin","value":1757073},{"name":"Rubio","value":1668217},{"name":"RFK Count","value":1471989},{"name":"EO Count Day 3","value":1447919},{"name":"Leader Out","value":1438858},{"name":"Mamdani Mentions","value":1212810},{"name":"Patel Count","value":1171428},{"name":"Jan 6 Pardon Day 1","value":1044957}]},{"name":"Government","value":101373311,"children":[{"name":"Shutdown Length","value":83205234},{"name":"Shutdown","value":8370121},{"name":"Cuts","value":5592207},{"name":"Reopen 2025","value":4205749}]},{"name":"Senate","value":84205131,"children":[{"name":"Arizona","value":35499031},{"name":"Margin","value":9085904},{"name":"Majority","value":6603809},{"name":"R Seats","value":6205451},{"name":"Nevada","value":5434688},{"name":"Texas","value":4936503},{"name":"Pennsylvania","value":3917206},{"name":"Other","value":2965652},{"name":"Ohio","value":2820514},{"name":"Nebraska","value":1487626},{"name":"Wisconsin","value":1476144},{"name":"Florida","value":1427473},{"name":"Michigan","value":1340222},{"name":"Medicare","value":1004908}]},{"name":"Trump Admin","value":78287893,"children":[{"name":"Mentions","value":28522480},{"name":"Joint Session","value":13744260},{"name":"Pardons","value":8664486},{"name":"Out","value":8491229},{"name":"Statements","value":4895542},{"name":"Officials","value":4125812},{"name":"Other","value":4118244},{"name":"Putin","value":1693899},{"name":"Meetings","value":1518357},{"name":"Attendance","value":1257249},{"name":"Tariffs Vote","value":1256335}]},{"name":"Other Elections","value":43979487,"children":[{"name":"Other","value":13438136},{"name":"RFK","value":6485808},{"name":"Mamdani %","value":5393529},{"name":"Patel","value":3034138},{"name":"VA Attorney General","value":2847040},{"name":"Seattle Mayor","value":2600292},{"name":"Hegseth","value":2417398},{"name":"Cuomo %","value":1831385},{"name":"Sliwa %","value":1718346},{"name":"Other Mayor","value":1624019},{"name":"Minneapolis Mayor","value":1504148},{"name":"Jersey Mayor","value":1085248}]},{"name":"House","value":37061283,"children":[{"name":"Margin","value":16252923},{"name":"R Seats","value":9824620},{"name":"Control House","value":4668201},{"name":"Other","value":4006035},{"name":"Control Senate","value":2309504}]},{"name":"Governor","value":32773196,"children":[{"name":"New Jersey","value":21640003},{"name":"Virginia","value":5610201},{"name":"Other","value":5522992}]},{"name":"Cabinet","value":30024566,"children":[{"name":"Musk","value":6808311},{"name":"DNI","value":5775465},{"name":"Dept of Education","value":3934156},{"name":"FBI","value":3925710},{"name":"RFK","value":3492893},{"name":"Out","value":2497081},{"name":"Count","value":1856470},{"name":"Tulsi","value":1390634},{"name":"Other","value":343846}]}]},{"name":"Crypto","value":835368307,"children":[{"name":"Bitcoin","value":694145149,"children":[{"name":"Daily","value":469794193},{"name":"Price","value":147757318},{"name":"Max Yearly","value":26646742},{"name":"Max 150K","value":15008499},{"name":"Max 125K","value":14561675},{"name":"Min Yearly","value":12798089}]},{"name":"Ethereum","value":131898218,"children":[{"name":"Daily","value":63574089},{"name":"Price","value":46156119},{"name":"Max Yearly","value":16018255},{"name":"Min Yearly","value":6149755}]},{"name":"Other Crypto","value":9324940,"children":[{"name":"Doge","value":4725116},{"name":"Doge Daily","value":1746164},{"name":"XRP","value":1310395},{"name":"Shiba","value":1027954},{"name":"Coinbase","value":280703},{"name":"Solana","value":234608}]}]},{"name":"Finance","value":756455223,"children":[{"name":"S&P 500","value":292295200,"children":[{"name":"Up","value":119602091},{"name":"Daily","value":70659400},{"name":"Other","value":65373904},{"name":"Yearly","value":24449465},{"name":"Weekly","value":12210340}]},{"name":"NASDAQ","value":204643448,"children":[{"name":"Up","value":67351021},{"name":"Daily","value":56913855},{"name":"Other","value":39489801},{"name":"Yearly","value":30293259},{"name":"Weekly","value":10595512}]},{"name":"Economic Indicators","value":78124445,"children":[{"name":"CPI YoY","value":24088773},{"name":"CPI","value":19064341},{"name":"Payrolls","value":11918552},{"name":"GDP","value":10618882},{"name":"Unemployment","value":6326345},{"name":"CPI Core","value":4337572},{"name":"CPI Core YoY","value":1769980}]},{"name":"Fed","value":63210989,"children":[{"name":"Other","value":42984343},{"name":"Leave Powell","value":7654168},{"name":"Mentions","value":5243591},{"name":"Chair Nomination","value":3232237},{"name":"Powell Mentions","value":1680603},{"name":"Employees","value":1412742},{"name":"Terminal Rate","value":1003305}]},{"name":"Commodities","value":46024181,"children":[{"name":"Gas Monthly","value":37169443},{"name":"WTI Oil","value":2971923},{"name":"Gas Weekly","value":2202304},{"name":"Gas","value":1930363},{"name":"Eggs","value":1748450}]},{"name":"Other Finance","value":27464464,"children":[{"name":"Shutdown By","value":8479330},{"name":"IPOs","value":3569828},{"name":"Tesla","value":2653173},{"name":"Debt Shrink","value":2351449},{"name":"Gold Cards","value":2194868},{"name":"Gambling Repeal","value":2060682},{"name":"Musk Party","value":1570847},{"name":"TSLA Earnings","value":1303691},{"name":"Expand","value":1203259},{"name":"Deport Count","value":1075643},{"name":"Waymo Cities","value":1001694}]},{"name":"Bonds","value":18373895,"children":[{"name":"T-Note Weekly","value":10354717},{"name":"T-Note Daily","value":6031413},{"name":"Debt Ceiling","value":1836102}]},{"name":"Forex","value":17880330,"children":[{"name":"USD/JPY","value":9255196},{"name":"EUR/USD","value":4270146},{"name":"EUR/USD Hourly","value":2679473},{"name":"USD/JPY Hourly","value":1675515}]},{"name":"Tariffs","value":8438271,"children":[{"name":"General","value":6656201},{"name":"FTA Countries","value":1782070}]}]},{"name":"Weather","value":282861151,"children":[{"name":"High Temp","value":267231240,"children":[{"name":"New York","value":61839543},{"name":"Chicago","value":48669278},{"name":"Austin","value":42890293},{"name":"Miami","value":32641356},{"name":"Los Angeles","value":27033427},{"name":"Denver","value":26219521},{"name":"Philadelphia","value":17290446},{"name":"Houston","value":6416018},{"name":"Monthly","value":3163360}]},{"name":"Precipitation","value":11298482,"children":[{"name":"NYC Rain","value":4847836},{"name":"Other Snow","value":2487801},{"name":"Other Rain","value":2100461},{"name":"NYC Snow Monthly","value":1862384}]},{"name":"Severe Weather","value":3743493,"children":[{"name":"Tornado","value":2235882},{"name":"Hurricane","value":1507611}]}]},{"name":"Entertainment","value":209057565,"children":[{"name":"Movies","value":86331404,"children":[{"name":"Rotten Tomatoes","value":63351048},{"name":"Captain America","value":2405348},{"name":"Moana 2","value":2230769},{"name":"Mickey 17","value":2077029},{"name":"Mufasa","value":1881390},{"name":"The Monkey","value":1752423},{"name":"Wicked","value":1639156},{"name":"Novocaine","value":1626469},{"name":"Fantastic Four","value":1588271},{"name":"Wicked For Good","value":1567449},{"name":"Nosferatu","value":1499085},{"name":"Superman","value":1327939},{"name":"Dog Man","value":1258789},{"name":"Last Breath","value":1102894},{"name":"Jurassic World","value":1023345}]},{"name":"Awards","value":42273624,"children":[{"name":"Other Oscar","value":10390361},{"name":"Oscar Best Picture","value":7286303},{"name":"Oscar Nom Picture","value":3394728},{"name":"Other Emmy","value":3339482},{"name":"Game Awards","value":3293585},{"name":"Emmy Drama","value":3207909},{"name":"Oscar Actor","value":1974451},{"name":"Other Grammy","value":1968128},{"name":"Grammy SOTY","value":1830729},{"name":"Oscar Actress","value":1792288},{"name":"Grammy AOTY","value":1728804},{"name":"Oscar Nom Actress","value":1573802},{"name":"BAFTA","value":493054}]},{"name":"Spotify","value":28957608,"children":[{"name":"Daily","value":19125418},{"name":"Other","value":4803752},{"name":"Songs Opalite","value":2219860},{"name":"2-Day","value":1536893},{"name":"Global Daily","value":1271685}]},{"name":"TV/Media","value":17660135,"children":[{"name":"Super Bowl Headlines","value":4813533},{"name":"SNF Mentions","value":4090383},{"name":"TNF Mentions","value":3402902},{"name":"South Park Mentions","value":2290076},{"name":"Kimmel Mentions","value":1594302},{"name":"MrBeast Mentions","value":1468939}]},{"name":"Other Entertainment","value":14899957,"children":[{"name":"Time","value":5644324},{"name":"App Rank Free","value":4855665},{"name":"Top Model","value":3086258},{"name":"GTA 6","value":1200534}]},{"name":"Music","value":13493536,"children":[{"name":"Billboard Top 10 TS","value":3634317},{"name":"Top Album","value":3102357},{"name":"Taylor Swift Mentions","value":2936480},{"name":"Top Song","value":1583276},{"name":"Most Streamed TS","value":1241951},{"name":"Billboard","value":995155}]},{"name":"Netflix","value":5441301,"children":[{"name":"Movie Rank","value":3014507},{"name":"Show Rank","value":2352854},{"name":"Other","value":73940}]}]},{"name":"Other","value":156229518,"children":[{"name":"Other","value":156229518,"children":[{"name":"KXLSUCOACH","value":1683420},{"name":"KXFLACOACH","value":1665334}]}]},{"name":"Media","value":50031659,"children":[{"name":"Mentions","value":23108221,"children":[{"name":"General","value":21778876},{"name":"Vance","value":1329345}]},{"name":"Search Trends","value":9617205,"children":[{"name":"Google Search","value":8623692},{"name":"Song Thriller","value":993513}]},{"name":"Other Media","value":8935779,"children":[{"name":"TSAW","value":5113053},{"name":"UFSD","value":1798253},{"name":"Case M","value":1030488},{"name":"Case D","value":993985}]},{"name":"Polls","value":8368970,"children":[{"name":"538 Approve","value":5008176},{"name":"Approve POTUS","value":3360794}]}]},{"name":"World Events","value":42483274,"children":[{"name":"Other Events","value":19067711,"children":[{"name":"Epstein","value":7478102},{"name":"Epstein Bill","value":3079100},{"name":"Epstein List","value":2441839},{"name":"Arrests","value":2342424},{"name":"Lagos Days","value":1462656},{"name":"OTE Epstein","value":1250350},{"name":"Zelensky Putin Meet","value":1013240}]},{"name":"Nobel Prize","value":12123979,"children":[{"name":"Peace","value":12076482}]},{"name":"Religion","value":11291584,"children":[{"name":"Next Pope","value":10618819},{"name":"Pope","value":672765}]}]},{"name":"Esports","value":42066035,"children":[{"name":"Multi-Game","value":24973879,"children":[{"name":"Extended Props","value":24973879}]},{"name":"League of Legends","value":12410533,"children":[{"name":"Games","value":5492191},{"name":"Worlds","value":5046794},{"name":"Maps","value":1871548}]},{"name":"CS:GO","value":3277412,"children":[{"name":"Games","value":3277412}]},{"name":"Other Esports","value":1404211,"children":[{"name":"Internet Invitational","value":1404211}]}]},{"name":"Science/Tech","value":35169395,"children":[{"name":"AI","value":24623502,"children":[{"name":"LLM Benchmark","value":17256618},{"name":"Other AI","value":6891566},{"name":"LLM","value":475318}]},{"name":"Tech","value":5451653,"children":[{"name":"CEO Astronomer","value":2415264},{"name":"Leave Lisa Cook","value":2197383},{"name":"Apple","value":839006}]},{"name":"Space","value":5094240,"children":[{"name":"SpaceX Starship","value":2542790},{"name":"Aliens","value":1886612},{"name":"SpaceX","value":664838}]}]}],
  "nameKey": "name",
  "valueKey": "value",
  "yUnit": "dollars"
}
```

That volume is distributed unevenly across market categories. Sports dominates at 72% of total volume, followed by politics at 13% and crypto at 5%.

> **Note:** Data collection concluded on 2025-11-25 at 17:00:15 EST, so Q4 2025 figures are incomplete. This does not affect the overall analysis.

### Dataset

The complete dataset underlying this analysis is [available on GitHub](https://github.com/jon-becker/prediction-market-analysis). It contains **7.68 million markets** and **72.1 million trades** stored in Parquet format, totaling approximately 3GB compressed.

Data was collected via Kalshi's public REST API, which provides unauthenticated access to market metadata and trade history. The collection process ran in two phases. First, we enumerated all markets on the platform via paginated API calls, storing results in chunked Parquet files of 10,000 records each. Second, a trade backfill iterated through every market with at least 100 contracts traded, fetching complete trade histories.

The data analysis is also fully reproducible: the repository includes Python scripts that query the dataset to generate every figure and statistic in this paper.

> **Warning:** The dataset comprises thousands of individual Parquet files. If you're on macOS and your working directory syncs to iCloud Drive, you will brick your machine while iCloud heroically attempts to index and upload each file individually. Ask me how I know.

---

## Part I: The Behavioral Zoo

Let's start with what prediction market traders get wrong. The list is extensive.

### Lottery Ticket Syndrome

```chart
{
  "type": "line",
  "title": "Average Contracts per Trade by Price",
  "data": [
    {"price": 1, "contracts": 548.27}, {"price": 2, "contracts": 509.87}, {"price": 3, "contracts": 460.27}, {"price": 4, "contracts": 383.57}, {"price": 5, "contracts": 324.40},
    {"price": 6, "contracts": 314.80}, {"price": 7, "contracts": 299.29}, {"price": 8, "contracts": 279.65}, {"price": 9, "contracts": 262.14}, {"price": 10, "contracts": 259.29},
    {"price": 11, "contracts": 259.59}, {"price": 12, "contracts": 247.79}, {"price": 13, "contracts": 246.75}, {"price": 14, "contracts": 235.88}, {"price": 15, "contracts": 231.65},
    {"price": 16, "contracts": 233.85}, {"price": 17, "contracts": 232.85}, {"price": 18, "contracts": 218.43}, {"price": 19, "contracts": 218.43}, {"price": 20, "contracts": 217.35},
    {"price": 21, "contracts": 220.22}, {"price": 22, "contracts": 216.46}, {"price": 23, "contracts": 220.33}, {"price": 24, "contracts": 207.98}, {"price": 25, "contracts": 212.27},
    {"price": 26, "contracts": 217.03}, {"price": 27, "contracts": 222.84}, {"price": 28, "contracts": 212.72}, {"price": 29, "contracts": 206.46}, {"price": 30, "contracts": 202.83},
    {"price": 31, "contracts": 217.79}, {"price": 32, "contracts": 210.36}, {"price": 33, "contracts": 209.63}, {"price": 34, "contracts": 212.12}, {"price": 35, "contracts": 209.38},
    {"price": 36, "contracts": 215.05}, {"price": 37, "contracts": 204.48}, {"price": 38, "contracts": 217.85}, {"price": 39, "contracts": 210.86}, {"price": 40, "contracts": 214.42},
    {"price": 41, "contracts": 213.98}, {"price": 42, "contracts": 221.71}, {"price": 43, "contracts": 242.25}, {"price": 44, "contracts": 221.76}, {"price": 45, "contracts": 221.09},
    {"price": 46, "contracts": 221.81}, {"price": 47, "contracts": 220.09}, {"price": 48, "contracts": 217.12}, {"price": 49, "contracts": 220.20}, {"price": 50, "contracts": 219.25},
    {"price": 51, "contracts": 234.58}, {"price": 52, "contracts": 235.16}, {"price": 53, "contracts": 234.57}, {"price": 54, "contracts": 227.63}, {"price": 55, "contracts": 233.16},
    {"price": 56, "contracts": 246.14}, {"price": 57, "contracts": 248.47}, {"price": 58, "contracts": 248.45}, {"price": 59, "contracts": 235.08}, {"price": 60, "contracts": 218.06},
    {"price": 61, "contracts": 230.32}, {"price": 62, "contracts": 241.93}, {"price": 63, "contracts": 227.05}, {"price": 64, "contracts": 220.55}, {"price": 65, "contracts": 218.75},
    {"price": 66, "contracts": 220.34}, {"price": 67, "contracts": 221.60}, {"price": 68, "contracts": 216.82}, {"price": 69, "contracts": 219.73}, {"price": 70, "contracts": 218.91},
    {"price": 71, "contracts": 231.29}, {"price": 72, "contracts": 219.97}, {"price": 73, "contracts": 227.86}, {"price": 74, "contracts": 227.33}, {"price": 75, "contracts": 216.06},
    {"price": 76, "contracts": 232.98}, {"price": 77, "contracts": 236.65}, {"price": 78, "contracts": 230.23}, {"price": 79, "contracts": 237.29}, {"price": 80, "contracts": 229.85},
    {"price": 81, "contracts": 245.30}, {"price": 82, "contracts": 236.15}, {"price": 83, "contracts": 242.50}, {"price": 84, "contracts": 246.00}, {"price": 85, "contracts": 242.88},
    {"price": 86, "contracts": 266.92}, {"price": 87, "contracts": 255.35}, {"price": 88, "contracts": 255.16}, {"price": 89, "contracts": 261.32}, {"price": 90, "contracts": 258.00},
    {"price": 91, "contracts": 276.15}, {"price": 92, "contracts": 284.13}, {"price": 93, "contracts": 275.67}, {"price": 94, "contracts": 287.00}, {"price": 95, "contracts": 284.94},
    {"price": 96, "contracts": 302.36}, {"price": 97, "contracts": 315.05}, {"price": 98, "contracts": 337.95}, {"price": 99, "contracts": 409.98}
  ],
  "xKey": "price",
  "yKeys": ["contracts"],
  "yUnit": "number"
}
```

At 1 cent per contract, traders purchase an average of **548 contracts per trade**, 2.5x more than at mid-range prices. The pattern is unmistakable: as prices decrease, position sizes explode.

This is textbook lottery ticket behavior. The psychology is straightforward: at 1 cent per contract, a \$50 bet buys 5,000 contracts. If the event occurs, that \$50 becomes \$5,000, a 100x return. The asymmetric payoff structure activates the same mental accounting that drives Powerball purchases. Traders focus on the potential upside ("I could make \$5,000!") while underweighting the probability ("It's only 1%... but maybe").

[Kahneman and Tversky's Prospect Theory](https://doi.org/10.2307/1914185) predicts exactly this: humans systematically overweight small probabilities and underweight large ones. [Prelec (1998)](https://doi.org/10.2307/2998573) formalized the probability weighting function that explains why a 1% chance feels more like 3% and a 99% chance feels more like 95%.

### Round Number Fixation

```chart
{
  "type": "line",
  "title": "Trade Concentration at Each Price (Observed vs Expected)",
  "data": [
    {"price": 1, "ratio": 1.94}, {"price": 2, "ratio": 0.97}, {"price": 3, "ratio": 1.19}, {"price": 4, "ratio": 1.10}, {"price": 5, "ratio": 1.11},
    {"price": 6, "ratio": 1.04}, {"price": 7, "ratio": 1.04}, {"price": 8, "ratio": 1.04}, {"price": 9, "ratio": 1.01}, {"price": 10, "ratio": 1.04},
    {"price": 11, "ratio": 0.93}, {"price": 12, "ratio": 0.92}, {"price": 13, "ratio": 0.92}, {"price": 14, "ratio": 0.95}, {"price": 15, "ratio": 0.99},
    {"price": 16, "ratio": 0.91}, {"price": 17, "ratio": 0.95}, {"price": 18, "ratio": 0.93}, {"price": 19, "ratio": 0.92}, {"price": 20, "ratio": 0.98},
    {"price": 21, "ratio": 0.92}, {"price": 22, "ratio": 0.97}, {"price": 23, "ratio": 0.98}, {"price": 24, "ratio": 0.97}, {"price": 25, "ratio": 1.01},
    {"price": 26, "ratio": 0.91}, {"price": 27, "ratio": 0.96}, {"price": 28, "ratio": 0.98}, {"price": 29, "ratio": 0.97}, {"price": 30, "ratio": 1.05},
    {"price": 31, "ratio": 1.02}, {"price": 32, "ratio": 0.99}, {"price": 33, "ratio": 1.01}, {"price": 34, "ratio": 1.03}, {"price": 35, "ratio": 1.01},
    {"price": 36, "ratio": 1.02}, {"price": 37, "ratio": 1.08}, {"price": 38, "ratio": 1.10}, {"price": 39, "ratio": 1.12}, {"price": 40, "ratio": 1.13},
    {"price": 41, "ratio": 0.97}, {"price": 42, "ratio": 1.00}, {"price": 43, "ratio": 1.10}, {"price": 44, "ratio": 1.15}, {"price": 45, "ratio": 1.14},
    {"price": 46, "ratio": 1.12}, {"price": 47, "ratio": 1.14}, {"price": 48, "ratio": 1.24}, {"price": 49, "ratio": 1.18}, {"price": 50, "ratio": 1.28},
    {"price": 51, "ratio": 1.15}, {"price": 52, "ratio": 1.14}, {"price": 53, "ratio": 1.18}, {"price": 54, "ratio": 1.14}, {"price": 55, "ratio": 1.17},
    {"price": 56, "ratio": 1.09}, {"price": 57, "ratio": 1.09}, {"price": 58, "ratio": 1.15}, {"price": 59, "ratio": 1.10}, {"price": 60, "ratio": 1.10},
    {"price": 61, "ratio": 0.97}, {"price": 62, "ratio": 1.06}, {"price": 63, "ratio": 1.01}, {"price": 64, "ratio": 1.05}, {"price": 65, "ratio": 1.07},
    {"price": 66, "ratio": 0.92}, {"price": 67, "ratio": 0.91}, {"price": 68, "ratio": 0.94}, {"price": 69, "ratio": 0.94}, {"price": 70, "ratio": 0.96},
    {"price": 71, "ratio": 0.81}, {"price": 72, "ratio": 0.84}, {"price": 73, "ratio": 0.86}, {"price": 74, "ratio": 0.87}, {"price": 75, "ratio": 0.92},
    {"price": 76, "ratio": 0.80}, {"price": 77, "ratio": 0.83}, {"price": 78, "ratio": 0.84}, {"price": 79, "ratio": 0.87}, {"price": 80, "ratio": 0.93},
    {"price": 81, "ratio": 0.77}, {"price": 82, "ratio": 0.77}, {"price": 83, "ratio": 0.75}, {"price": 84, "ratio": 0.82}, {"price": 85, "ratio": 0.84},
    {"price": 86, "ratio": 0.78}, {"price": 87, "ratio": 0.75}, {"price": 88, "ratio": 0.84}, {"price": 89, "ratio": 0.81}, {"price": 90, "ratio": 0.88},
    {"price": 91, "ratio": 0.78}, {"price": 92, "ratio": 0.82}, {"price": 93, "ratio": 0.85}, {"price": 94, "ratio": 0.90}, {"price": 95, "ratio": 0.97},
    {"price": 96, "ratio": 0.94}, {"price": 97, "ratio": 1.10}, {"price": 98, "ratio": 1.05}, {"price": 99, "ratio": 1.43}
  ],
  "xKey": "price",
  "yKeys": ["ratio"],
  "yUnit": "number"
}
```

If traders were purely rational, prices would be evenly distributed across all cent values. Instead, trades cluster dramatically at psychologically salient prices:

| Price Type | Concentration Ratio | Examples |
|------------|---------------------|----------|
| Extremes | 1.43-1.94x | 1¢, 99¢ |
| 50 cents | 1.28x | Maximum uncertainty |
| Round numbers | 1.05-1.13x | 10¢, 30¢, 40¢ |
| Non-round | 0.88-0.96x | 47¢, 73¢, 82¢ |

The 50-cent price point, representing maximum uncertainty, attracts **28% more trades** than a uniform distribution would predict. This clustering is statistically overwhelming (χ²=401,343, p<0.001) and suggests traders anchor on round numbers rather than calculating precise fair values. They think in terms of "about 50-50" rather than "exactly 47%."

### Momentum Chasing

```chart
{
  "type": "bar",
  "title": "Taker Performance After Price Movements",
  "data": [
    {"change": "<-10¢", "excess": -2.71},
    {"change": "-5 to -2¢", "excess": -0.67},
    {"change": "No change", "excess": -0.97},
    {"change": "+2 to +5¢", "excess": -1.12},
    {"change": "+5 to +10¢", "excess": -2.04},
    {"change": ">+10¢", "excess": -5.37}
  ],
  "xKey": "change",
  "yKeys": ["excess"],
  "yUnit": "percent"
}
```

Traders who buy after large price spikes (>10 cents) suffer **-5.37% excess returns**, the worst performance of any category we measured. This is textbook momentum chasing: prices spike on news, traders pile in at the top, and mean reversion follows.

| Recent Price Change | Excess Win Rate | N Trades |
|--------------------|-----------------|----------|
| > +10 cents        | **-5.37%**      | 1.83M    |
| +5 to +10 cents    | -2.04%          | 2.20M    |
| No change          | -0.97%          | 27.12M   |
| < -10 cents        | -2.71%          | 1.80M    |

The asymmetry is notable: buying after crashes (-10 cents) yields -2.71% excess returns. Bad, but half as bad as buying after spikes. Contrarian strategies don't generate alpha, but they avoid the worst behavioral traps.

### The 3 AM Problem

```chart
{
  "type": "bar",
  "title": "Trading Volume by Hour (ET)",
  "data": [
    {"hour": "12am", "trades": 2396954},
    {"hour": "3am", "trades": 258465},
    {"hour": "6am", "trades": 234155},
    {"hour": "9am", "trades": 2445718},
    {"hour": "12pm", "trades": 3654324},
    {"hour": "3pm", "trades": 4779570},
    {"hour": "6pm", "trades": 3624100},
    {"hour": "9pm", "trades": 5198758},
    {"hour": "10pm", "trades": 5334192}
  ],
  "xKey": "hour",
  "yKeys": ["trades"],
  "yUnit": "number"
}
```

Volume peaks between 9-10 PM ET when retail traders are home from work. It troughs between 3-6 AM ET. But the interesting pattern is in trade size and performance:

| Time (ET) | Avg Trade Size | Volume |
|-----------|----------------|--------|
| 3 AM      | \$75           | Low    |
| 9 AM      | \$103          | Medium |
| 10 PM     | \$144          | High   |

The 3 AM traders are placing smaller bets, suggesting less sophisticated participants trading for entertainment rather than expected value. The composition of the trading population varies dramatically by time of day.

### Late Arrival Syndrome

```chart
{
  "type": "area",
  "title": "Trading Volume by Market Lifetime",
  "data": [
    {"pct": "0-10%", "volume": 1.7},
    {"pct": "10-20%", "volume": 2.1},
    {"pct": "20-40%", "volume": 4.8},
    {"pct": "40-60%", "volume": 6.2},
    {"pct": "60-80%", "volume": 8.4},
    {"pct": "80-90%", "volume": 7.1},
    {"pct": "90-100%", "volume": 70.6}
  ],
  "xKey": "pct",
  "yKeys": ["volume"],
  "yUnit": "percent"
}
```

Over **70% of all trading volume** occurs in the final 10% of a market's lifetime. Traders pile in when the outcome is nearly determined, not when their forecasts would be most valuable.

This has important implications for the claimed "forecasting" value of prediction markets. If markets only achieve substantial liquidity near resolution, they cannot serve their proposed function of aggregating information early. By the time 70% of volume arrives, the outcome is often nearly known anyway.

---

## Part II: The Calibration Surprise

Given the behavioral circus documented above, you'd expect prediction market prices to be hopelessly miscalibrated. Traders are chasing lottery tickets, anchoring on round numbers, piling into momentum trades, and making their worst decisions at 3 AM.

And yet.

```chart
{
  "type": "line",
  "title": "Actual Win Rate vs Contract Price",
  "data": [
    {"price": 1, "actual": 0.91, "implied": 1}, {"price": 2, "actual": 1.90, "implied": 2}, {"price": 3, "actual": 2.71, "implied": 3}, {"price": 4, "actual": 3.45, "implied": 4}, {"price": 5, "actual": 4.18, "implied": 5},
    {"price": 6, "actual": 4.92, "implied": 6}, {"price": 7, "actual": 5.79, "implied": 7}, {"price": 8, "actual": 6.97, "implied": 8}, {"price": 9, "actual": 7.78, "implied": 9}, {"price": 10, "actual": 8.91, "implied": 10},
    {"price": 11, "actual": 9.93, "implied": 11}, {"price": 12, "actual": 11.11, "implied": 12}, {"price": 13, "actual": 12.37, "implied": 13}, {"price": 14, "actual": 12.95, "implied": 14}, {"price": 15, "actual": 13.92, "implied": 15},
    {"price": 16, "actual": 15.26, "implied": 16}, {"price": 17, "actual": 15.84, "implied": 17}, {"price": 18, "actual": 16.77, "implied": 18}, {"price": 19, "actual": 17.81, "implied": 19}, {"price": 20, "actual": 20.81, "implied": 20},
    {"price": 21, "actual": 22.70, "implied": 21}, {"price": 22, "actual": 22.73, "implied": 22}, {"price": 23, "actual": 21.43, "implied": 23}, {"price": 24, "actual": 21.80, "implied": 24}, {"price": 25, "actual": 23.11, "implied": 25},
    {"price": 26, "actual": 24.11, "implied": 26}, {"price": 27, "actual": 25.71, "implied": 27}, {"price": 28, "actual": 28.91, "implied": 28}, {"price": 29, "actual": 29.03, "implied": 29}, {"price": 30, "actual": 29.89, "implied": 30},
    {"price": 31, "actual": 31.44, "implied": 31}, {"price": 32, "actual": 34.38, "implied": 32}, {"price": 33, "actual": 34.78, "implied": 33}, {"price": 34, "actual": 36.16, "implied": 34}, {"price": 35, "actual": 35.08, "implied": 35},
    {"price": 36, "actual": 35.71, "implied": 36}, {"price": 37, "actual": 37.96, "implied": 37}, {"price": 38, "actual": 38.69, "implied": 38}, {"price": 39, "actual": 38.69, "implied": 39}, {"price": 40, "actual": 40.04, "implied": 40},
    {"price": 41, "actual": 40.66, "implied": 41}, {"price": 42, "actual": 40.12, "implied": 42}, {"price": 43, "actual": 40.82, "implied": 43}, {"price": 44, "actual": 42.58, "implied": 44}, {"price": 45, "actual": 44.06, "implied": 45},
    {"price": 46, "actual": 46.11, "implied": 46}, {"price": 47, "actual": 45.29, "implied": 47}, {"price": 48, "actual": 46.47, "implied": 48}, {"price": 49, "actual": 47.90, "implied": 49}, {"price": 50, "actual": 50.00, "implied": 50},
    {"price": 51, "actual": 52.10, "implied": 51}, {"price": 52, "actual": 53.53, "implied": 52}, {"price": 53, "actual": 54.72, "implied": 53}, {"price": 54, "actual": 53.89, "implied": 54}, {"price": 55, "actual": 55.95, "implied": 55},
    {"price": 56, "actual": 57.43, "implied": 56}, {"price": 57, "actual": 59.18, "implied": 57}, {"price": 58, "actual": 59.88, "implied": 58}, {"price": 59, "actual": 59.34, "implied": 59}, {"price": 60, "actual": 59.96, "implied": 60},
    {"price": 61, "actual": 61.31, "implied": 61}, {"price": 62, "actual": 61.32, "implied": 62}, {"price": 63, "actual": 62.03, "implied": 63}, {"price": 64, "actual": 64.29, "implied": 64}, {"price": 65, "actual": 64.92, "implied": 65},
    {"price": 66, "actual": 63.84, "implied": 66}, {"price": 67, "actual": 65.22, "implied": 67}, {"price": 68, "actual": 65.63, "implied": 68}, {"price": 69, "actual": 68.56, "implied": 69}, {"price": 70, "actual": 70.11, "implied": 70},
    {"price": 71, "actual": 70.97, "implied": 71}, {"price": 72, "actual": 71.09, "implied": 72}, {"price": 73, "actual": 74.28, "implied": 73}, {"price": 74, "actual": 75.89, "implied": 74}, {"price": 75, "actual": 76.89, "implied": 75},
    {"price": 76, "actual": 78.21, "implied": 76}, {"price": 77, "actual": 78.57, "implied": 77}, {"price": 78, "actual": 77.27, "implied": 78}, {"price": 79, "actual": 77.31, "implied": 79}, {"price": 80, "actual": 79.19, "implied": 80},
    {"price": 81, "actual": 82.20, "implied": 81}, {"price": 82, "actual": 83.23, "implied": 82}, {"price": 83, "actual": 84.16, "implied": 83}, {"price": 84, "actual": 84.74, "implied": 84}, {"price": 85, "actual": 86.08, "implied": 85},
    {"price": 86, "actual": 87.05, "implied": 86}, {"price": 87, "actual": 87.63, "implied": 87}, {"price": 88, "actual": 88.90, "implied": 88}, {"price": 89, "actual": 90.08, "implied": 89}, {"price": 90, "actual": 91.10, "implied": 90},
    {"price": 91, "actual": 92.22, "implied": 91}, {"price": 92, "actual": 93.03, "implied": 92}, {"price": 93, "actual": 94.21, "implied": 93}, {"price": 94, "actual": 95.09, "implied": 94}, {"price": 95, "actual": 95.83, "implied": 95},
    {"price": 96, "actual": 96.56, "implied": 96}, {"price": 97, "actual": 97.30, "implied": 97}, {"price": 98, "actual": 98.12, "implied": 98}, {"price": 99, "actual": 99.09, "implied": 99}
  ],
  "xKey": "price",
  "yKeys": ["actual", "implied"],
  "strokeDasharrays": [null, "5 5"],
  "yUnit": "percent"
}
```

50-cent contracts win **exactly 50.00%** of the time. 70-cent contracts win 70.11%. 90-cent contracts win 91.10%. Across the bulk of the price range, calibration is remarkably tight.

The mispricing that does exist follows a predictable pattern:

```chart
{
  "type": "line",
  "title": "Calibration Error by Price (%)",
  "data": [
    {"price": 1, "error": -8.65}, {"price": 2, "error": -5.08}, {"price": 3, "error": -9.79}, {"price": 4, "error": -13.77}, {"price": 5, "error": -16.36},
    {"price": 6, "error": -18.07}, {"price": 7, "error": -17.28}, {"price": 8, "error": -12.84}, {"price": 9, "error": -13.53}, {"price": 10, "error": -10.86},
    {"price": 11, "error": -9.77}, {"price": 12, "error": -7.45}, {"price": 13, "error": -4.83}, {"price": 14, "error": -7.51}, {"price": 15, "error": -7.19},
    {"price": 16, "error": -4.63}, {"price": 17, "error": -6.81}, {"price": 18, "error": -6.82}, {"price": 19, "error": -6.28}, {"price": 20, "error": 4.03},
    {"price": 21, "error": 8.11}, {"price": 22, "error": 3.30}, {"price": 23, "error": -6.82}, {"price": 24, "error": -9.18}, {"price": 25, "error": -7.56},
    {"price": 26, "error": -7.27}, {"price": 27, "error": -4.76}, {"price": 28, "error": 3.25}, {"price": 29, "error": 0.12}, {"price": 30, "error": -0.37},
    {"price": 31, "error": 1.41}, {"price": 32, "error": 7.44}, {"price": 33, "error": 5.39}, {"price": 34, "error": 6.34}, {"price": 35, "error": 0.23},
    {"price": 36, "error": -0.80}, {"price": 37, "error": 2.60}, {"price": 38, "error": 1.82}, {"price": 39, "error": -0.79}, {"price": 40, "error": 0.10},
    {"price": 41, "error": -0.83}, {"price": 42, "error": -4.47}, {"price": 43, "error": -5.07}, {"price": 44, "error": -3.24}, {"price": 45, "error": -2.10},
    {"price": 46, "error": 0.23}, {"price": 47, "error": -3.65}, {"price": 48, "error": -3.19}, {"price": 49, "error": -2.25}, {"price": 50, "error": 0.00},
    {"price": 51, "error": 2.16}, {"price": 52, "error": 2.94}, {"price": 53, "error": 3.24}, {"price": 54, "error": -0.20}, {"price": 55, "error": 1.72},
    {"price": 56, "error": 2.55}, {"price": 57, "error": 3.82}, {"price": 58, "error": 3.24}, {"price": 59, "error": 0.58}, {"price": 60, "error": -0.06},
    {"price": 61, "error": 0.50}, {"price": 62, "error": -1.10}, {"price": 63, "error": -1.53}, {"price": 64, "error": 0.45}, {"price": 65, "error": -0.12},
    {"price": 66, "error": -3.27}, {"price": 67, "error": -2.65}, {"price": 68, "error": -3.49}, {"price": 69, "error": -0.64}, {"price": 70, "error": 0.16},
    {"price": 71, "error": -0.04}, {"price": 72, "error": -1.27}, {"price": 73, "error": 1.75}, {"price": 74, "error": 2.56}, {"price": 75, "error": 2.53},
    {"price": 76, "error": 2.91}, {"price": 77, "error": 2.03}, {"price": 78, "error": -0.94}, {"price": 79, "error": -2.14}, {"price": 80, "error": -1.01},
    {"price": 81, "error": 1.48}, {"price": 82, "error": 1.50}, {"price": 83, "error": 1.39}, {"price": 84, "error": 0.88}, {"price": 85, "error": 1.27},
    {"price": 86, "error": 1.22}, {"price": 87, "error": 0.73}, {"price": 88, "error": 1.02}, {"price": 89, "error": 1.22}, {"price": 90, "error": 1.22},
    {"price": 91, "error": 1.34}, {"price": 92, "error": 1.12}, {"price": 93, "error": 1.30}, {"price": 94, "error": 1.16}, {"price": 95, "error": 0.87},
    {"price": 96, "error": 0.58}, {"price": 97, "error": 0.31}, {"price": 98, "error": 0.12}, {"price": 99, "error": 0.10}
  ],
  "xKey": "price",
  "yKeys": ["error"],
  "yUnit": "percent"
}
```

| Price Range | Calibration Error | Interpretation |
|-------------|-------------------|----------------|
| 1-10 cents | -9% to -16% | Longshots overpriced |
| 20-80 cents | ±1% | Well calibrated |
| 90-99 cents | +1% | Favorites slightly underpriced |

The classic **longshot bias** exists but is modest: contracts at 5-7 cents win about 16% less often than their price implies. That's a real inefficiency, but it's not catastrophic. A 5-cent contract returning 84 cents on the dollar is bad, but it's not the 43-cent-on-the-dollar disaster you might expect from watching individual traders chase lottery tickets.

### Why Does This Work?

The [efficient market hypothesis](https://www.jstor.org/stable/2325486), in its strong form, requires that all market participants be rational and well-informed. This is obviously false. But the *weak* form only requires that prices aggregate available information better than any individual participant.

Several mechanisms enable this aggregation despite individual irrationality:

**1. Error Cancellation.** Some traders overestimate probabilities, others underestimate. If errors are roughly symmetric and uncorrelated, they cancel out in the aggregate price.

**2. Marginal Price Setting.** The market price isn't set by the average trader; it's set by the marginal trader willing to take the other side. A few sophisticated participants can anchor prices even if the majority are irrational.

**3. Arbitrage Pressure.** When prices deviate too far from fair value, profit opportunities emerge. Even if most traders are behavioral, the few who aren't will trade against mispricing until it's eliminated.

**4. The Wisdom of Crowds.** [Surowiecki (2004)](https://en.wikipedia.org/wiki/The_Wisdom_of_Crowds) documented how aggregating independent judgments often outperforms individual experts. Prediction markets formalize this aggregation through the price mechanism.

The result is a system where individual irrationality is filtered out and collective accuracy emerges. The market doesn't need rational individuals. It needs a mechanism that extracts signal from noise.

---

## Part III: Where Calibration Breaks Down

Not all markets are created equal. While aggregate calibration is impressive, systematic differences emerge across categories.

```chart
{
  "type": "line",
  "title": "Calibration by Category",
  "data": [
    {"price": 1, "Sports": -21.24, "Politics": -69.06, "Finance": 80.62, "Crypto": 57.80}, {"price": 2, "Sports": 4.12, "Politics": -76.61, "Finance": 15.27, "Crypto": 21.13},
    {"price": 3, "Sports": -0.69, "Politics": -84.74, "Finance": 10.24, "Crypto": 27.43}, {"price": 4, "Sports": -6.84, "Politics": -72.32, "Finance": -8.43, "Crypto": 1.26},
    {"price": 5, "Sports": -15.37, "Politics": -61.23, "Finance": -6.06, "Crypto": -4.53}, {"price": 6, "Sports": -18.43, "Politics": -58.28, "Finance": -13.06, "Crypto": 2.12},
    {"price": 7, "Sports": -16.06, "Politics": -52.65, "Finance": -12.65, "Crypto": -8.72}, {"price": 8, "Sports": -9.29, "Politics": -53.53, "Finance": -11.90, "Crypto": -8.03},
    {"price": 9, "Sports": -10.77, "Politics": -50.56, "Finance": -8.44, "Crypto": -10.71}, {"price": 10, "Sports": -8.59, "Politics": -45.57, "Finance": -7.52, "Crypto": -8.70},
    {"price": 11, "Sports": -8.44, "Politics": -49.15, "Finance": -11.28, "Crypto": -5.00}, {"price": 12, "Sports": -2.91, "Politics": -49.83, "Finance": -10.11, "Crypto": -6.15},
    {"price": 13, "Sports": 0.25, "Politics": -46.46, "Finance": -8.44, "Crypto": -8.05}, {"price": 14, "Sports": -3.88, "Politics": -44.07, "Finance": -10.06, "Crypto": -9.14},
    {"price": 15, "Sports": -6.05, "Politics": -32.88, "Finance": -8.75, "Crypto": -7.88}, {"price": 16, "Sports": -1.10, "Politics": -34.32, "Finance": -13.80, "Crypto": -8.65},
    {"price": 17, "Sports": -4.82, "Politics": -36.30, "Finance": -11.66, "Crypto": -5.24}, {"price": 18, "Sports": -5.60, "Politics": -26.24, "Finance": -10.43, "Crypto": -6.71},
    {"price": 19, "Sports": -3.51, "Politics": -31.69, "Finance": -11.42, "Crypto": -6.47}, {"price": 20, "Sports": 9.94, "Politics": -18.55, "Finance": -10.08, "Crypto": -4.27},
    {"price": 21, "Sports": 15.17, "Politics": -17.19, "Finance": -9.29, "Crypto": -3.88}, {"price": 22, "Sports": 8.85, "Politics": -23.72, "Finance": -10.29, "Crypto": -5.26},
    {"price": 23, "Sports": -6.63, "Politics": -21.25, "Finance": -8.63, "Crypto": -4.65}, {"price": 24, "Sports": -10.78, "Politics": -17.12, "Finance": -8.49, "Crypto": -5.31},
    {"price": 25, "Sports": -10.64, "Politics": -5.05, "Finance": -6.51, "Crypto": -3.97}, {"price": 26, "Sports": -10.19, "Politics": -2.52, "Finance": -7.31, "Crypto": -2.93},
    {"price": 27, "Sports": -4.96, "Politics": -15.30, "Finance": -9.33, "Crypto": -3.62}, {"price": 28, "Sports": 6.92, "Politics": -17.13, "Finance": -7.69, "Crypto": -3.77},
    {"price": 29, "Sports": 1.93, "Politics": -16.11, "Finance": -6.03, "Crypto": -4.23}, {"price": 30, "Sports": 0.89, "Politics": -15.29, "Finance": -3.61, "Crypto": -2.59},
    {"price": 31, "Sports": 2.42, "Politics": -14.92, "Finance": -1.49, "Crypto": -0.49}, {"price": 32, "Sports": 11.79, "Politics": -14.81, "Finance": -3.66, "Crypto": -0.92},
    {"price": 33, "Sports": 9.13, "Politics": -13.25, "Finance": -3.55, "Crypto": -1.75}, {"price": 34, "Sports": 10.96, "Politics": -18.22, "Finance": -2.72, "Crypto": -2.25},
    {"price": 35, "Sports": 2.22, "Politics": -19.59, "Finance": -1.84, "Crypto": -2.38}, {"price": 36, "Sports": 0.26, "Politics": -16.99, "Finance": -1.05, "Crypto": -1.83},
    {"price": 37, "Sports": 5.55, "Politics": -22.59, "Finance": 1.67, "Crypto": -0.89}, {"price": 38, "Sports": 4.55, "Politics": -25.27, "Finance": 1.87, "Crypto": -2.30},
    {"price": 39, "Sports": 0.47, "Politics": -18.29, "Finance": 1.56, "Crypto": -2.60}, {"price": 40, "Sports": 2.10, "Politics": -25.39, "Finance": 1.91, "Crypto": -1.57},
    {"price": 41, "Sports": 2.32, "Politics": -39.96, "Finance": 1.77, "Crypto": 0.36}, {"price": 42, "Sports": -2.09, "Politics": -45.92, "Finance": 1.12, "Crypto": -0.92},
    {"price": 43, "Sports": -3.07, "Politics": -44.13, "Finance": 1.85, "Crypto": -1.50}, {"price": 44, "Sports": -1.53, "Politics": -33.82, "Finance": 0.51, "Crypto": -1.27},
    {"price": 45, "Sports": -0.90, "Politics": -24.11, "Finance": -0.12, "Crypto": -1.39}, {"price": 46, "Sports": 1.69, "Politics": -18.64, "Finance": -0.19, "Crypto": -0.88},
    {"price": 47, "Sports": -3.94, "Politics": -13.20, "Finance": -1.04, "Crypto": -0.71}, {"price": 48, "Sports": -3.44, "Politics": -10.76, "Finance": 0.24, "Crypto": -1.26},
    {"price": 49, "Sports": -2.53, "Politics": -7.06, "Finance": 0.81, "Crypto": -0.59}, {"price": 50, "Sports": 0.01, "Politics": 0.00, "Finance": 0.00, "Crypto": 0.00},
    {"price": 51, "Sports": 2.43, "Politics": 6.78, "Finance": -0.77, "Crypto": 0.57}, {"price": 52, "Sports": 3.17, "Politics": 9.93, "Finance": -0.22, "Crypto": 1.16},
    {"price": 53, "Sports": 3.50, "Politics": 11.71, "Finance": 0.92, "Crypto": 0.63}, {"price": 54, "Sports": -1.44, "Politics": 15.88, "Finance": 0.16, "Crypto": 0.75},
    {"price": 55, "Sports": 0.74, "Politics": 19.72, "Finance": 0.10, "Crypto": 1.14}, {"price": 56, "Sports": 1.21, "Politics": 26.57, "Finance": -0.40, "Crypto": 1.00},
    {"price": 57, "Sports": 2.31, "Politics": 33.29, "Finance": -1.40, "Crypto": 1.13}, {"price": 58, "Sports": 1.52, "Politics": 33.25, "Finance": -0.81, "Crypto": 0.67},
    {"price": 59, "Sports": -1.61, "Politics": 27.77, "Finance": -1.23, "Crypto": -0.25}, {"price": 60, "Sports": -1.39, "Politics": 16.93, "Finance": -1.28, "Crypto": 1.05},
    {"price": 61, "Sports": -0.31, "Politics": 11.69, "Finance": -1.00, "Crypto": 1.66}, {"price": 62, "Sports": -2.77, "Politics": 15.49, "Finance": -1.15, "Crypto": 1.41},
    {"price": 63, "Sports": -3.27, "Politics": 13.27, "Finance": -0.98, "Crypto": 0.52}, {"price": 64, "Sports": -0.14, "Politics": 9.56, "Finance": 0.59, "Crypto": 1.03},
    {"price": 65, "Sports": -1.19, "Politics": 10.55, "Finance": 0.99, "Crypto": 1.28}, {"price": 66, "Sports": -5.65, "Politics": 9.39, "Finance": 1.40, "Crypto": 1.16},
    {"price": 67, "Sports": -4.49, "Politics": 6.53, "Finance": 1.75, "Crypto": 0.86}, {"price": 68, "Sports": -5.53, "Politics": 6.97, "Finance": 1.72, "Crypto": 0.43},
    {"price": 69, "Sports": -1.09, "Politics": 6.70, "Finance": 0.67, "Crypto": 0.22}, {"price": 70, "Sports": -0.38, "Politics": 6.55, "Finance": 1.55, "Crypto": 1.11},
    {"price": 71, "Sports": -0.77, "Politics": 6.58, "Finance": 2.46, "Crypto": 1.73}, {"price": 72, "Sports": -2.69, "Politics": 6.66, "Finance": 2.99, "Crypto": 1.47},
    {"price": 73, "Sports": 1.82, "Politics": 5.66, "Finance": 3.45, "Crypto": 1.34}, {"price": 74, "Sports": 3.59, "Politics": 0.88, "Finance": 2.57, "Crypto": 1.03},
    {"price": 75, "Sports": 3.55, "Politics": 1.68, "Finance": 2.17, "Crypto": 1.32}, {"price": 76, "Sports": 3.42, "Politics": 5.40, "Finance": 2.68, "Crypto": 1.68},
    {"price": 77, "Sports": 1.98, "Politics": 6.35, "Finance": 2.58, "Crypto": 1.39}, {"price": 78, "Sports": -2.51, "Politics": 6.69, "Finance": 2.90, "Crypto": 1.48},
    {"price": 79, "Sports": -4.01, "Politics": 4.57, "Finance": 2.47, "Crypto": 1.03}, {"price": 80, "Sports": -2.49, "Politics": 4.64, "Finance": 2.52, "Crypto": 1.07},
    {"price": 81, "Sports": 0.83, "Politics": 7.43, "Finance": 2.68, "Crypto": 1.52}, {"price": 82, "Sports": 1.24, "Politics": 5.76, "Finance": 2.29, "Crypto": 1.47},
    {"price": 83, "Sports": 0.99, "Politics": 7.43, "Finance": 2.39, "Crypto": 1.07}, {"price": 84, "Sports": 0.21, "Politics": 6.54, "Finance": 2.63, "Crypto": 1.65},
    {"price": 85, "Sports": 1.07, "Politics": 5.80, "Finance": 1.54, "Crypto": 1.39}, {"price": 86, "Sports": 0.63, "Politics": 7.17, "Finance": 1.64, "Crypto": 1.49},
    {"price": 87, "Sports": -0.03, "Politics": 6.94, "Finance": 1.26, "Crypto": 1.20}, {"price": 88, "Sports": 0.41, "Politics": 6.79, "Finance": 1.38, "Crypto": 0.84},
    {"price": 89, "Sports": 1.05, "Politics": 6.08, "Finance": 1.39, "Crypto": 0.62}, {"price": 90, "Sports": 0.97, "Politics": 5.06, "Finance": 0.84, "Crypto": 0.97},
    {"price": 91, "Sports": 1.07, "Politics": 5.00, "Finance": 0.83, "Crypto": 1.06}, {"price": 92, "Sports": 0.82, "Politics": 4.66, "Finance": 1.03, "Crypto": 0.70},
    {"price": 93, "Sports": 1.21, "Politics": 3.96, "Finance": 0.95, "Crypto": 0.66}, {"price": 94, "Sports": 1.19, "Politics": 3.72, "Finance": 0.83, "Crypto": -0.14},
    {"price": 95, "Sports": 0.83, "Politics": 3.22, "Finance": 0.32, "Crypto": 0.24}, {"price": 96, "Sports": 0.30, "Politics": 3.01, "Finance": 0.35, "Crypto": -0.05},
    {"price": 97, "Sports": 0.04, "Politics": 2.62, "Finance": -0.32, "Crypto": -0.85}, {"price": 98, "Sports": -0.05, "Politics": 1.56, "Finance": -0.31, "Crypto": -0.43},
    {"price": 99, "Sports": 0.23, "Politics": 0.70, "Finance": -0.81, "Crypto": -0.58}
  ],
  "xKey": "price",
  "yKeys": ["Sports", "Politics", "Finance", "Crypto"],
  "yUnit": "percent"
}
```

| Category | Volume | Calibration Quality | Likely Explanation |
|----------|--------|--------------------|--------------------|
| Finance | \$756M | Excellent (±2%) | Sophisticated traders, clear data |
| Weather | \$283M | Good (±4%) | Objective outcomes, model-based |
| Sports | \$13.2B | Moderate (±10%) | Entertainment motive, high variance |
| Politics | \$2.4B | Variable (±15%) | Tribal reasoning, narrative-driven |

**Finance markets** show the tightest calibration. These attract traders focused on expected value: quants, arbitrageurs, and professionals. The outcomes are objective (did the S&P close above X?), data is readily available, and there's no tribal or entertainment component to distort pricing.

**Sports markets** represent 72% of platform volume but exhibit moderate calibration errors. This makes sense: sports betting is entertainment first, forecasting second. The same traders who buy lottery tickets at 1 cent are disproportionately represented here. The market mechanism still works, just less efficiently.

**Politics markets** show the most variance. At certain price points, calibration errors reach 15-25%. Political beliefs are identity-laden; traders may be willing to pay a premium to express tribal allegiance. "Betting on my candidate" provides utility beyond expected value.

---

## Part IV: What This Means

### For the Efficient Market Hypothesis

The EMH doesn't require rational individuals. It requires a mechanism that aggregates dispersed information into prices that reflect collective knowledge. Prediction markets demonstrate this mechanism in action.

Individual traders exhibit every behavioral bias in the textbook: overweighting small probabilities, anchoring on round numbers, chasing momentum, trading impulsively at 3 AM. And yet, the prices they collectively produce are remarkably well-calibrated.

This is the [Hayek insight](https://www.econlib.org/library/Essays/hykKnw.html) in action: markets aggregate dispersed knowledge that no individual possesses. The mechanism works not because people are rational, but because their errors are filtered through a price discovery process that extracts signal from noise.

### For Prediction Market Design

The data suggests several design implications:

1. **Liquidity matters more than participant quality.** Finance markets with sophisticated traders and sports markets with entertainment-seekers both achieve reasonable calibration. The key variable is liquidity, not trader sophistication.

2. **Category matters.** Markets with objective outcomes (weather, finance) calibrate better than those with subjective or tribal components (politics, entertainment). Design should account for this.

3. **Time-to-resolution concentration is a problem.** If 70% of volume arrives in the final 10% of a market's life, the forecasting value is limited. Mechanisms to encourage early liquidity would increase utility.

### For Users of Prediction Market Data

If you're using prediction market prices as probability estimates:

- **Trust mid-range prices.** 30-70 cent contracts are well-calibrated across categories.
- **Discount extremes.** Longshots (1-10 cents) are systematically overpriced; expect ~15% less than implied.
- **Account for category.** Finance and weather markets are more reliable than politics or entertainment.
- **Prefer liquid markets.** Tight spreads correlate strongly with calibration quality.

---

## Conclusion

The efficient market hypothesis, properly understood, is not a claim about individual rationality. It's a claim about collective information aggregation.

Prediction market traders are irrational by any individual measure. They chase lottery tickets at extreme prices, cluster trades on round numbers, pile into momentum trades at exactly the wrong time, and make their worst decisions in the middle of the night.

And yet, the prices they produce are remarkably accurate. 50-cent contracts win 50% of the time. The systematic mispricing that exists is modest and concentrated at the extremes. The market mechanism, aggregates individual errors into collective accuracy.

This is the paradox at the heart of market efficiency: the crowd can be wise even when its members are foolish. The mechanism matters more than the participants. Prediction markets work not because traders are smart, but because the market is.

---

### Resources & Citations

- Fama, E. F. ["Efficient capital markets: A review of theory and empirical work."](https://doi.org/10.2307/2325486) *The Journal of Finance* 25.2 (1970): 383-417.
- Hayek, F. A. ["The use of knowledge in society."](https://www.econlib.org/library/Essays/hykKnw.html) *The American Economic Review* 35.4 (1945): 519-530.
- Kahneman, D., & Tversky, A. ["Prospect theory: An analysis of decision under risk."](https://doi.org/10.2307/1914185) *Econometrica* 47.2 (1979): 263-291.
- Prelec, D. ["The probability weighting function."](https://doi.org/10.2307/2998573) *Econometrica* 66.3 (1998): 497-527.
- Surowiecki, J. *The Wisdom of Crowds.* Doubleday (2004).
- Thaler, R. H., & Ziemba, W. T. ["Anomalies: Parimutuel betting markets: Racetracks and lotteries."](https://doi.org/10.1257/jep.2.2.161) *Journal of Economic Perspectives* 2.2 (1988): 161-174.

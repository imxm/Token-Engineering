# LightLink LBP Sale - Post-Mortem Report

### **Introduction**
LightLink, an Ethereum Layer 2 blockchain, conducted a successful Liquidity Bootstrapping Pool (LBP) sale hosted on the Fjord Foundry platform. This event raised $5.28 million from 3,581 participants, ensuring fair price discovery and broad token distribution. This report examines the strategic parameters set by BlockApex that contributed to this success.

### **About LightLink**
LightLink is designed to facilitate instant, gasless transactions tailored for decentralized applications (dApps) and enterprises. It targets enterprises requiring predictable gas fees and high throughput, offering a seamless user experience through direct interactions with web3 wallets.

#### **Mainnet Statistics (as of the time of writing):**
- **Daily Transactions:** ~126,000
- **Total Transactions:** 29,859,676
- **Wallets:** 590,180
- **Total Contracts:** 30,474

### **Token Sale Models**
The landscape of token launch models in the cryptocurrency domain is diverse. For LightLink, the LBP model was chosen due to its ability to ensure fair market price discovery and broad token distribution.

#### **Comparison of Token Sale Models:**

| Feature              | Fixed Price | AMM          | Dutch Auction  | Lockdrop + LBA | LBP                        |
|----------------------|-------------|--------------|----------------|----------------|---------------------------|
| **Price Discovery**  | Predetermined | Market-driven | Descending price | Market-driven with lockdrop | Market-driven with weight ratios |
| **Liquidity**        | Dependent on market makers | High initial liquidity | Can be variable | High initial liquidity | High initial liquidity |
| **Distribution**     | Based on investment amount | Based on liquidity provision | Based on bid price | Reward-based with LBA | Based on price and timing |
| **Risks**            | Price manipulation, low liquidity | Impermanent loss | Price volatility, bot attacks | Complex mechanism, All LP associated Risks | Complex mechanism, potential for manipulation |

### **Why LBP Strategy for LightLink**
The LBP model was selected for several key advantages over other token sale mechanisms:
- **Fair Price Discovery:** Gradual price decrease helps in finding a fair market value for the token.
- **Wide Token Distribution:** Encourages a larger number of participants to buy tokens at various price points.
- **Prevention of Manipulation:** High initial prices and controlled liquidity make it difficult for early buyers or large investors to manipulate the price.
- **Community Engagement:** Involves the community in the price discovery process, making it more inclusive and fair.

### **Strategic Parameter Setting for the LBP**
The success of the LBP sale hinged on several carefully set strategic parameters:

#### **Initial Price and Weight Settings**
- **Initial Token Price:** Set high to prevent early manipulation (~$0.93 per token).
- **Liquidity Provided:** 158 ETH (valued at $485,000) was provided as initial liquidity.
- **Token Supply:** 5% of the total token supply (50 million tokens) was offered in the LBP.
- **Starting and Ending Weights:** The pool started with a 99/1 LL/WETH weight and gradually shifted to a 1/99 WETH/LL weight.

### **LBP Math**
The price in a Liquidity Bootstrapping Pool (LBP) is determined by weights and balances, with prices decreasing over time due to the algorithmic adjustment of weights. This dynamic pricing is influenced by the balance of the project token and the reserve token in the pool.

#### **Effective Price Formula:**
\[ P = \left( \frac{Bo - Ao}{Bi} \right)^{\left(\frac{Wo}{Wi}\right)} \]

Where:
- \( Bo \) and \( Bi \) represent the project token and reserve token balances.
- \( Wo \) and \( Wi \) represent the weights of the two tokens.
- \( Ao \) represents the trade size at each step in terms of project tokens.

#### **Price Discovery and Distribution Dynamics**
- **Decreasing Price Mechanism:** The LBP’s dynamic pricing involved a systematic decrease in price over time, encouraging fair distribution.
- **Participation and Distribution:** 49.82 million tokens sold, with the final on-chain price around $0.209 per token, reflecting true market value.

### **Managing Volatility and Ensuring Fair Sale**
- **ETH Volatility Adjustment:** Incorporated based on a 90-day average volatility of 3.67%, ensuring stability.
- **Price Manipulation Prevention:** High initial prices and dynamic weight adjustments discouraged early large-scale purchases and potential manipulation.

### **Analysis and Outcomes**
- **Funds Raised:** $5.28 million
- **Tokens Sold:** 49.82 million tokens
- **Final On-Chain Price:** ~$0.209 per token
- **Participants:** 3,581 wallets

### **Strategic Recommendations and Findings**
- **Setting Initial Prices and Weights:** High initial prices combined with strategic weight settings prevent manipulation and ensure fair price discovery.
- **Provision of Adequate Liquidity:** Crucial for establishing a stable starting price and facilitating smooth trades.
- **Token Supply Management:** Offering a standard percentage of the total supply ensures accurate price discovery.
- **Dynamic Weight Adjustments:** Encourages broader participation and ensures fair token distribution.
- **Utilization of Simulations and Participant Behavior Modeling:** Instrumental in determining optimal parameters, predicting an average price range of $0.15-$0.20.

### **Conclusion**
Strategic parameter setting in LBPs is crucial for shaping market dynamics and achieving a project's long-term goals. The collaboration between BlockApex and LightLink in conducting the LBP sale on Fjord Foundry demonstrates the importance of strategic parameter setting in successful fundraising and fair market practices.

**Does your project have a similar need?** Partner with BlockApex to leverage our expertise in strategic parameter setting and innovative fundraising models. **[Contact us](mailto:contact@blockapex.com)** today to learn how we can help you design and execute a successful token sale, ensuring fair price discovery, broad token distribution, and robust community engagement.

# BlockApex Tokenomics Design for Midl Dapp by Alacritys

## **Introduction**
The Midl Dapp by Alacritys is a decentralized application designed to facilitate on-ramp and off-ramp transactions with a unique dispute resolution mechanism. The Dapp incorporates a robust economic model, incentivizing users, custodians, and jury members while ensuring a secure and transparent ecosystem.

## **Protocol Operational Mechanics, Architecture, and Tokenomics Design**
### **Architecture and Workflow**
#### **Protocol Workflow**
The workflow represents the interaction of all agents (users, custodians, and jury members) at an arm's length transaction.

#### **Custodian Onboarding**
Custodians must deposit collateral to onboard the Midl Dapp. This collateral is locked in the vault, allowing custodians to facilitate transactions equivalent to 80% of the collateral value.

### **On-ramp Transactions**
Users can deposit fiat by placing an order through the Custodian Dapp. Custodians accept the order, receive fiat, and the contract mints wrapped versions of the currency.

### **Off-ramp Transactions**
For withdrawals, users submit a request via the Custodian Dapp. Upon acceptance, the wrapped currency is burned, and the custodian transfers fiat to the user's bank account.

### **Explanation of Caveats**
The system is fully collateral-backed, ensuring a 1:1 peg between fiat and wrapped currency. Custodians can only facilitate transactions up to 80% of their collateral value.

## **Dispute Resolution Mechanism**
### **Jury Mechanism**
A jury of 11 members is assigned to resolve disputes. The decision is based on a simple majority (6 out of 11 votes). Jury members must maintain a stake equivalent to 10% of the disputed transaction value.

### **Protocol Appeal Board Mechanism**
Parties can appeal against a jury decision by paying a refundable fee. The appeal board examines the evidence and either reinforces or overturns the jury's decision. Jury members who make incorrect judgments may face slashing penalties.

## **Economic Model**
### **Fee Structure Model**
- **Deposit Fee**: Ramp fee of 5 USD.
- **Withdrawal Fee**: Ramp fee of 5 USD plus a batch fee of 0.2 USD.
- **Batch Fee Distribution**: 
  - 30% for token swap and burn.
  - 5% to batch owner (user).
  - 9% to batch facilitator (custodian).
  - 10% to the founding team.
  - 25% for future development.
  - 21% to the custodian category reward pool.
- **Ramp Fee Distribution**:
  - 99% to custodian.
  - 1% to jury.

### **Reward Distribution / Slashing Mechanism**
Rewards are distributed through various fees accumulated by the protocol, including batch and ramp fees. Custodians and jury members are rewarded based on their participation and performance.

### **Batches of Users**
Users earn rewards when their batch is used to facilitate a transaction. Rewards are calculated and stored in the user's balance, with 20% available for immediate claim and 80% locked in an accrued pool.

### **Custodian Rewards**
Custodians earn rewards from both the ramp fee and batch fee. Custodians are categorized based on their transaction volume, with higher categories earning greater rewards.

### **Categorization of Custodians**
Custodians are categorized into Platinum, Gold, Silver, and Regular based on their cumulative transaction volume.

### **Jury Rewards**
Jury members earn rewards from the ramp fee and additional rewards for correct dispute resolutions. Jury members are categorized based on the number of disputes resolved.

### **Additional Jury Rewards**
Jury members can earn additional rewards equivalent to 75% of the slashed amount from the losing party in a dispute.

## **Game Theoretic Principles**
### **Incentives, Disincentives, and Slashing Mechanism**
The protocol employs a range of incentives to encourage desired behavior and disincentives to prevent malicious activities.

#### **User Incentives**
- Users are incentivized to bring fiat into the ecosystem through batch rewards.
- Disincentives include slashing for initiating false disputes or appeals.

#### **Custodian Incentives**
- Custodians are incentivized to facilitate on/off-ramp activities and can earn category rewards.
- Custodians involved in fraudulent activities face slashing penalties.

#### **Jury Incentives**
- Jury members earn rewards for correct judgments and can lose rewards for incorrect ones.
- Jury members must stake tokens to participate in the dispute resolution process.

### **Yield Generation Strategies**
The protocol will invest the collateral deposited by custodians in low-risk yield generation strategies within decentralized finance, such as liquid staking, stablecoin liquidity provision, and lending strategies.

## **Functional Requirements**
- **User Onboarding**: Registration, authentication, and category assignment for users, custodians, and jury members.
- **Collateral Management**: Collateral deposit and business limit tied to transaction volumes.
- **Fiat Transactions**: Facilitation of on-ramp/off-ramp transactions and fee distribution.
- **Dispute Management**: Dispute initiation, jury selection, voting, and resolution.
- **Appeal Management**: Appeal initiation, decision-making, and reward/penalty application.
- **Rewards and Penalties Distribution**: Calculation and distribution of rewards and penalties.
- **Batching and FIFO-based Rewards**: Tracking user batches and applying the FIFO principle for reward distribution.
- **Reporting and Analytics**: Performance tracking and report generation for disputes, appeals, rewards, and penalties.

This README file provides a high-level overview of the Midl Dapp by Alacritys, covering its architecture, operational mechanics, economic model, and the incentive mechanisms designed to maintain a balanced and secure ecosystem.
https://docs.google.com/document/d/11mOzaiL1JAhdKlw5Vkhqir8Jwpla6foCT85geRCreaM/edit

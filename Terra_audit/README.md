# Terra/Luna Economic Audit - Post-Mortem and Digital Twin Report

### **Project Overview**
This repository contains a detailed post-mortem and digital twin analysis of the Terra/Luna ecosystem. Our case study provides insights and learnings from economic modeling and quantitative analysis of decentralized finance (DeFi) protocols, with a specific focus on the stability mechanisms of Terra/Luna. This work is designed to assist policymakers and stakeholders in making informed decisions.

### **Project Details**
- **Start Date:** January 15, 2024
- **Project Name:** Terra/Luna Economic Audit
- **Project Type:** Economic Analysis
- **Authors:** imxm, abd, Moazzama
- **Revised By:** imxm, jderyl

### **Summary**
We simulated Terra/Luna’s stability mechanism (arbitration) under various volatile market conditions and identified that the Virtual Liquidity Pool (VLP) replenishment module, in its current configurations, is insufficient to maintain stability. We derived an equation suggesting that VLP replenishment should be algorithmically updated instead of being managed by governance systems, with VLP parameters as a function of Luna’s volatility.

### **Project Structure**

1. **Recap of the Events**
   - **Modeling Terra:**
     - Pre-Columbus 3 Treasury Module
     - Post-Columbus 3 Market Module (VLP)
   - **Game Design of Terra Actors and Finding Bad Equilibrium**
   - **Analysis of Selecting the Game Play**
   - **Stochastic Model of Terra Ecosystem**
   - **Methodology of Simulation**
   - **Results and Findings**
   - **Future Work**

2. **Timeline**
   - Research and Project Selection: Jan 15 - Jan 23
   - Applying Synthetix Havven/Nomins Simulator: Jan 24 - Feb 5
   - Creating Stochastic Model: Feb 6 - Mar 20

### **Methodology**
- **Research and Project Selection:** 
  - Utilized the JBBA Tokenomics Audit Framework to guide the selection of Terra/Luna as a case study, leveraging its historical data for in-depth analysis.
  
- **Modeling Terra’s Ecosystem:**
  - Detailed the transition from Terra’s Treasury Module to the Market Module post-Columbus 3.
  - Conducted a game-theory analysis to identify equilibrium conditions that could lead to systemic risks.
  
- **Simulation Methodology:**
  - Developed a stochastic model using Gaussian distributions to simulate market behaviors and stress test the Terra ecosystem under varying volatility scenarios.

### **Findings**
- **Simulation Results:**
  - Normal Conditions: High failure rate observed in maintaining the peg under normal conditions.
  - Reserve Intervention: Introduction of a reserve pool significantly improved peg stability.
  - Adaptive Replenishment System: Showed varying effectiveness in different market conditions, highlighting the need for adaptive strategies.

### **Future Work**
- Further refinement of the stochastic model.
- Exploration of alternative stability mechanisms.
- Continuous testing and development of adaptive strategies for improving the robustness of algorithmic stablecoins.

### **How to Use the Model**
- **Simulation Execution:**
  - Run simulations using the provided MATLAB functions to observe the effects of different market conditions on the Terra/Luna ecosystem.
  - Modify parameters to test different configurations of the VLP and reserve mechanisms.

- **Key Functions:**
  - `runSimulation`: Executes the main simulation loop.
  - `SPRrandomSwaps`: Simulates random swaps in secondary pools.
  - `VPRandomSwaps`: Simulates random swaps in the virtual liquidity pool.
  - `VPArbitrage`: Models arbitrage behavior within the VLP.
  - `restoreDelta`: Adjusts the pool's state post-swap.

### **Contributing**
Contributions to enhance the model and analysis are welcome. Please submit pull requests with detailed explanations of any changes or improvements.

### **Contact**
For inquiries or further discussion, please open an issue or reach out to the authors directly.

### **Read more**
https://hackmd.io/thd3xqcHQnKg2YDe8pgxUw

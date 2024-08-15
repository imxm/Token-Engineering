import matplotlib.pyplot as plt

def calculate_price(usd_balance, ll_balance, ll_weight, usdc_weight, lot_size, swap_fee):
    if ll_balance <= lot_size:
        return float('inf')  # Avoid division by zero

    price = (usd_balance * ((ll_balance / (ll_balance - lot_size)) ** (ll_weight / usdc_weight) - 1)) / \
            (1 - swap_fee) / lot_size
    return price

# Inputs
initial_token_balance = 50000000  # Initial token balance
initial_usd_balance = 148485  # Placeholder value for USD balance
start_weights = (0.99, 0.01)  # Starting weights for token and USD
end_weights = (0.05, 0.95)  # Ending weights for token and USD
lot_size = 10000  # Size of each lot sold
swap_fee = 0.02  # Swap fee as a percentage
steps = 72  # Number of steps in the simulation
total_sale_rate_percent = 0.91  # Total sale rate as a percentage of the initial token balance over 72 steps

# Calculate total sale tokens based on the total sale rate
total_sale_tokens = initial_token_balance * total_sale_rate_percent

# Convert total sale tokens to hourly sale tokens
hourly_sale_tokens = total_sale_tokens / steps

# Arrays to store results
price_curve = []
token_balances = [initial_token_balance]
usd_balances = [initial_usd_balance]

# Simulation over specified steps
for step in range(steps):
    # Linear weight adjustment
    current_ll_weight = start_weights[0] + (end_weights[0] - start_weights[0]) * (step / steps)
    current_usdc_weight = start_weights[1] + (end_weights[1] - start_weights[1]) * (step / steps)

    # Calculate price
    price = calculate_price(usd_balances[-1], token_balances[-1], current_ll_weight, current_usdc_weight, lot_size, swap_fee)
    price_curve.append(price)

    # Simulate sales based on the hourly sale rate and current price
    tokens_sold = min(hourly_sale_tokens, token_balances[-1])  # Ensure we don't sell more tokens than available
    usd_received = tokens_sold * price

    # Update balances
    new_token_balance = token_balances[-1] - tokens_sold
    new_usd_balance = usd_balances[-1] + usd_received
    token_balances.append(new_token_balance)
    usd_balances.append(new_usd_balance)

# Calculate total proceeds and unsold tokens
total_proceeds = usd_balances[-1] - initial_usd_balance
unsold_tokens = token_balances[-1]

# Output results
print("Total Proceeds:", total_proceeds)
print("Unsold Tokens:", unsold_tokens)

# Plotting the price curve
plt.plot(range(steps), price_curve)
plt.title("Price Curve over 72 Steps")
plt.xlabel("Step (Hourly)")
plt.ylabel("Price")
plt.show()

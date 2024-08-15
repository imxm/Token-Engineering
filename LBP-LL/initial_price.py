import matplotlib.pyplot as plt

def calculate_lbp_price(tkn_balance, usdc_balance, tkn_weight, usdc_weight, swap_fee):
    """
    Calculate the initial starting price of an LBP.

    Parameters:
    tkn_balance (float): Token balance
    usdc_balance (float): USDC balance
    tkn_weight (float): Token weight
    usdc_weight (float): USDC weight
    swap_fee (float): Swap fee

    Returns:
    float: The resultant price based on the given parameters
    """
    try:
        price = usdc_balance * ((tkn_balance / (tkn_balance - 1))**(tkn_weight / usdc_weight) - 1) / (1 - swap_fee)
        return price
    except Exception as e:
        return f"Error: {e}"

# Hardcoded initial parameters
tkn_balance = 50000000
tkn_weight = 0.99
usdc_weight = 0.01
swap_fee = 0.02

# Iterating over different USDC balances
usdc_balances = [50000, 100000, 150000, 200000, 250000, 300000, 350000, 400000, 450000, 500000]
prices = []

for usdc_balance in usdc_balances:
    price = calculate_lbp_price(tkn_balance, usdc_balance, tkn_weight, usdc_weight, swap_fee)
    prices.append(price)

# Plotting the results
plt.figure(figsize=(10, 6))
plt.plot(usdc_balances, prices, marker='o')
plt.title('Impact of USDC Balance on LBP Starting Price')
plt.xlabel('USDC Balance')
plt.ylabel('Resultant Price')
plt.grid(True)
plt.show()


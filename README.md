# Vending Machine
Design a vending machine:
- The vending machine, once a product is selected and the appropriate amount of money (coins) is inserted, should return that product.
- It should also return change (coins) if too much money is provided or ask for more money (coins) if there is not enough (change should be printed as coin.
- The scenario where the item is out of stock or the machine does not have enough change to return to the customer should be considered.
- Available coins: 0.25, 0.5, 1, 2, 3, 5


# Installation and launch

### Docker approach
```console
   docker build -t vending-machine
   docker run -i -t vending-machine
```

### Native approach
```console
   bundle install
   ruby ./run.rb
```
### Tests
```console
   rspec spec
```

# Initial state
Initialized with the following products in showcase:

| Product Name | Price | Quantity |
|--------------|-------|----------|
| Snickers     | 1.50  |    2     |
| Oreo         | 9.00  |    2     |
| M$M's        | 2.00  |    2     |
| Cheetos      | 0.75  |    2     |
| Coca Cola    | 0.75  |    2     |
| BonAqua      | 2.00  |    2     |

Initialized with the following coins in cash box:

| Value | Quantity |
|-------|----------|
| 2.00  | 5        |
| 1.00  | 5        |
| 0.50  | 5        |
| 0.20  | 5        |
| 0.10  | 5        |
| 0.05  | 5        |
| 0.02  | 5        |
| 0.01  | 5        |

require './app/components/display'
require './app/components/showcase'
require './app/components/cash_box'

# VendingMachine class represents a vending machine object that allows users to select a product
# and pay for it using coins.
class VendingMachine
  def initialize
    @display = Display.new
    @showcase = Showcase.new
    @cash_box = CashBox.new
    @balance = 0
  end

  # Starts the vending machine and allows users to select a product, pay for it with coins,
  # and receive change if necessary.
  def start
    @display.welcome_message
    loop do
      product = process_product_select
      break if product.nil?

      change_coins = process_payment(product)
      @display.show_paid_product(product_name: product[:name])
      show_change(change_coins)
      @display.show_current_balance(balance: @balance) if @balance.positive?
    end
  end

  private

  def process_product_select
    product = @display.show_product_options(products: @showcase.available_products)
    return if product.nil?

    price = @balance > product[:price] ? 0 : product[:price] - @balance
    @display.show_selected_product(product_name: product[:name], price:)
    @showcase.destroy(id: product[:id])
    product
  end

  def process_payment(product)
    item_price = product[:price]
    while @balance < item_price
      @display.show_current_balance(balance: @balance)
      coin = @display.show_coin_options(coins: CashBox::POSSIBLE_COINS)
      @cash_box.add(id: coin[:value])
      @balance += coin[:value]
    end
    process_change(item_price)
  end

  def process_change(item_price)
    change_amount = @balance - item_price
    change_coins = []
    if change_amount.positive?
      change_coins = @cash_box.gather_change(change_amount:)
      change_coins.each { |coin| @cash_box.destroy(id: coin) }
      @balance = change_amount - change_coins.sum
    else
      @balance = 0
    end

    change_coins
  end

  def show_change(coins)
    if @balance.positive?
      @display.show_incomplete_change(coins:)
    else
      @display.show_change(coins:)
    end
  end
end

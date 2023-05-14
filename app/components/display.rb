# frozen_string_literal: true

require 'tty-prompt'

# Display class that manages the display and user interface for the vending machine
class Display
  def initialize(prompt: TTY::Prompt.new(interrupt: :exit))
    @prompt = prompt
  end

  # Displays a welcome message for the user
  def welcome_message
    @prompt.ok("I'm up and running. Press Ctrl+C to finish.")
  end

  # Displays a list of product options for the user to choose from
  def show_product_options(products:)
    @prompt.warn('Unfortunately, the products have run out.') and return if products.empty?

    items = products.map do |product|
      {
        name: "name: #{product[:name]}, price: #{format_money(product[:price])}, count: #{product[:count]}",
        value: product
      }
    end
    @prompt.select('Please select a product', items)
  end

  # Displays the selected product and prompts the user to insert the required payment
  def show_selected_product(product_name:, price:)
    messages = ["You selected #{product_name}."]
    messages << if price.positive?
                  "Insert #{format_money(price)}."
                else
                  'Your product is paid.'
                end
    @prompt.ok(messages.join(' '))
  end

  # Displays a message telling the user to take the paid product
  def show_paid_product(product_name:)
    @prompt.ok("Please take your #{product_name}.")
  end

  # Displays a list of coin options for the user to pay for the product
  def show_coin_options(coins:)
    items = coins.map do |coin|
      {
        name: format_money(coin[:value]),
        value: coin
      }
    end
    @prompt.select('Insert your coin', items)
  end

  # Displays the user's current balance
  def show_current_balance(balance:)
    @prompt.ok("Your balance #{format_money(balance)}.")
  end

  # Displays the user's change (if any)
  def show_change(coins:)
    @prompt.ok("Your change #{format_coins(coins)}.") unless coins.empty?
  end

  # Displays a warning message indicating that the vending machine cannot provide the required change
  def show_incomplete_change(coins:)
    messages = ['Unfortunately, the system could not collect the required change due to a lack of coins.']
    messages << 'But you have the rest on your balance.'
    messages << "Your change #{format_coins(coins)}." unless coins.empty?
    @prompt.warn(messages.join("\n"))
  end

  private

  def format_coins(coins)
    coins.map { |el| format_money(el) }.join(', ')
  end

  def format_money(price)
    "#{format('%.2f', price / 100.0)}$"
  end
end

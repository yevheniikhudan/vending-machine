# frozen_string_literal: true

require './core/vending_machine'
require './core/parts/showcase'
require './core/parts/cash_box'

RSpec.describe VendingMachine do
  subject(:start_vending_machine) { vending_machine.start }

  let(:vending_machine) { described_class.new }
  let(:cash_box) { CashBox.new(initiate_empty: true) }
  let(:showcase) { Showcase.new(initiate_empty: true) }
  let(:prompt) do
    instance_double(TTY::Prompt,
                    ok: 'ok',
                    warn: 'warn')
  end

  shared_context 'with products and change coins in the vending machine' do
    let(:products_in_showcase) do
      [{ id: 1, name: 'Snickers', price: 150, count: 1 },
       { id: 2, name: 'Oreo', price: 900, count: 1 },
       { id: 3, name: "M&M's", price: 200, count: 1 }]
    end
    let(:coins_in_change) do
      [{ value: 25 },
       { value: 50 },
       { value: 200 }]
    end
    let(:formatted_products) do
      products_in_showcase.map do |product|
        {
          name: ["name: #{product[:name]}",
                 "price: #{format('%.2f', product[:price] / 100.0)}$",
                 'count: 1'].join(', '),
          value: product
        }
      end
    end
    let(:formatted_coins) do
      CashBox::POSSIBLE_COINS.map do |coin|
        { name: "#{format('%.2f', coin[:value] / 100.0)}$", value: coin }
      end
    end

    before do
      products_in_showcase.each { |el| showcase.add(id: el[:id]) }
      coins_in_change.each { |el| cash_box.add(id: el[:value]) }
    end
  end

  before do
    allow(TTY::Prompt).to receive(:new).and_return(prompt)
    allow(CashBox).to receive(:new).and_return(cash_box)
    allow(Showcase).to receive(:new).and_return(showcase)
    allow(vending_machine).to receive(:loop).and_yield
  end

  context 'when both `CashBox` and `Showcase` are empty' do
    before do
      allow(prompt).to receive(:select).and_return(nil)
    end

    it {
      start_vending_machine
      expect(prompt).to have_received(:ok).with("I'm up and running. Press Ctrl+C to finish.")
      expect(prompt).to have_received(:warn).with('Unfortunately, the products have run out.')
    }
  end

  context 'when there is no need to calculate change' do
    include_context 'with products and change coins in the vending machine'

    before do
      allow(prompt).to receive(:select).with(
        'Please select a product', formatted_products
      ).and_return(products_in_showcase[2])
      allow(prompt).to receive(:select).with(
        'Insert your coin', formatted_coins
      ).and_return(coins_in_change[2])
    end

    it {
      start_vending_machine
      expect(prompt).to have_received(:ok).with("I'm up and running. Press Ctrl+C to finish.")
      expect(prompt).to have_received(:select).with('Please select a product', formatted_products)
      expect(prompt).to have_received(:ok).with("You selected M&M's. Insert 2.00$.")
      expect(prompt).to have_received(:select).with('Insert your coin', formatted_coins)
      expect(prompt).to have_received(:ok).with("Please take your M&M's.")
    }
  end

  context 'when there are change to calculate' do
    include_context 'with products and change coins in the vending machine'

    before do
      allow(prompt).to receive(:select).with(
        'Please select a product', formatted_products
      ).and_return(products_in_showcase[0])
      allow(prompt).to receive(:select).with(
        'Insert your coin', formatted_coins
      ).and_return(coins_in_change[2])
    end

    it {
      start_vending_machine
      expect(prompt).to have_received(:ok).with("I'm up and running. Press Ctrl+C to finish.")
      expect(prompt).to have_received(:select).with('Please select a product', formatted_products)
      expect(prompt).to have_received(:ok).with('You selected Snickers. Insert 1.50$.')
      expect(prompt).to have_received(:select).with('Insert your coin', formatted_coins)
      expect(prompt).to have_received(:ok).with('Please take your Snickers.')
      expect(prompt).to have_received(:ok).with('Your change 0.50$.')
    }
  end

  context 'when there are not enough change coins to process proper change' do
    include_context 'with products and change coins in the vending machine'

    before do
      allow(prompt).to receive(:select).with(
        'Please select a product', formatted_products
      ).and_return(products_in_showcase[1])
      allow(prompt).to receive(:select).with(
        'Insert your coin', formatted_coins
      ).and_return(coins_in_change[2])
    end

    it {
      start_vending_machine
      expect(prompt).to have_received(:ok).with("I'm up and running. Press Ctrl+C to finish.")
      expect(prompt).to have_received(:select).with('Please select a product', formatted_products)
      expect(prompt).to have_received(:ok).with('You selected Oreo. Insert 9.00$.')
      expect(prompt).to have_received(:select).with('Insert your coin', formatted_coins).exactly(5).times
      expect(prompt).to have_received(:ok).with('Please take your Oreo.')
      expect(prompt).to have_received(:warn).with(
        ['Unfortunately, the system could not collect the required change due to a lack of coins.',
         'But you have the rest on your balance.',
         'Your change 0.50$, 0.25$.'].join("\n")
      )
      expect(prompt).to have_received(:ok).with('Your balance 0.25$.')
    }
  end
end

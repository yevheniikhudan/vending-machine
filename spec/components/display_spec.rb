# frozen_string_literal: true

require './app/components/display'

RSpec.describe Display do
  subject(:display) { Display.new(prompt:) }

  let(:prompt) do
    instance_double(TTY::Prompt,
                    ok: 'ok',
                    warn: 'warn',
                    select: { dummy_key: 'dummy_value' })
  end

  describe '#welcome_message' do
    subject(:welcome_message) { display.welcome_message }

    it {
      expect(welcome_message).to eq('ok')
      expect(prompt).to have_received(:ok).with(
        "I'm up and running. Press Ctrl+C to finish."
      )
    }
  end

  describe '#show_product_options' do
    subject(:show_product_options) { display.show_product_options(products:) }

    context 'when products are empty' do
      let(:products) { [] }

      it {
        expect(show_product_options).to eq(nil)
        expect(prompt).to have_received(:warn).with(
          'Unfortunately, the products have run out.'
        )
      }
    end

    context 'when there are products to display' do
      let(:products) do
        [
          { name: 'Snickers', price: 150, count: 1 },
          { name: 'Oreo', price: 900, count: 2 }
        ]
      end

      it {
        expect(show_product_options).to eq({ dummy_key: 'dummy_value' })
        expect(prompt).to have_received(:select).with(
          'Please select a product',
          products.map do |product|
            {
              name: "name: #{product[:name]}, price: #{format('%.2f', product[:price] / 100.0)}$, count: #{product[:count]}",
              value: product
            }
          end
        )
      }
    end
  end

  describe '#show_selected_product' do
    subject(:show_selected_product) { display.show_selected_product(product_name:, price:) }

    let(:product_name) { 'dummy name' }

    context 'when product is paid' do
      let(:price) { 0 }

      it {
        expect(show_selected_product).to eq('ok')
        expect(prompt).to have_received(:ok).with(
          'You selected dummy name. Your product is paid.'
        )
      }
    end

    context 'when product need payment' do
      let(:price) { 250 }

      it {
        expect(show_selected_product).to eq('ok')
        expect(prompt).to have_received(:ok).with(
          'You selected dummy name. Insert 2.50$.'
        )
      }
    end
  end

  describe '#show_paid_product' do
    subject(:show_paid_product) { display.show_paid_product(product_name:) }

    let(:product_name) { 'dummy name' }

    it {
      expect(show_paid_product).to eq('ok')
      expect(prompt).to have_received(:ok).with(
        'Please take your dummy name.'
      )
    }
  end

  describe '#show_coin_options' do
    subject(:show_coin_options) { display.show_coin_options(coins:) }

    let(:coins) { [{ value: 25 }, { value: 50 }] }

    it {
      expect(show_coin_options).to eq({ dummy_key: 'dummy_value' })
      expect(prompt).to have_received(:select).with(
        'Insert your coin', [{ name: '0.25$', value: { value: 25 } },
                             { name: '0.50$', value: { value: 50 } }]
      )
    }
  end

  describe '#show_current_balance' do
    subject(:show_current_balance) { display.show_current_balance(balance:) }

    let(:balance) { 0 }

    it {
      expect(show_current_balance).to eq('ok')
      expect(prompt).to have_received(:ok).with(
        'Your balance 0.00$.'
      )
    }
  end

  describe '#show_change' do
    subject(:show_change) { display.show_change(coins:) }

    context 'when coins for change are empty' do
      let(:coins) { [] }

      it {
        expect(show_change).to eq(nil)
        expect(prompt).not_to have_received(:ok)
      }
    end

    context 'when there are coins to display' do
      let(:coins) { [25, 50, 100] }

      it {
        expect(show_change).to eq('ok')
        expect(prompt).to have_received(:ok).with(
          'Your change 0.25$, 0.50$, 1.00$.'
        )
      }
    end
  end

  describe '#show_incomplete_change' do
    subject(:show_incomplete_change) { display.show_incomplete_change(coins:) }

    context 'when coins for change are empty' do
      let(:coins) { [] }

      it {
        expect(show_incomplete_change).to eq('warn')
        expect(prompt).to have_received(:warn).with(
          ['Unfortunately, the system could not collect the required change due to a lack of coins.',
           'But you have the rest on your balance.'].join("\n")
        )
      }
    end

    context 'when there are coins to display' do
      let(:coins) { [25, 50, 100] }

      it {
        expect(show_incomplete_change).to eq('warn')
        expect(prompt).to have_received(:warn).with(
          ['Unfortunately, the system could not collect the required change due to a lack of coins.',
           'But you have the rest on your balance.',
           'Your change 0.25$, 0.50$, 1.00$.'].join("\n")
        )
      }
    end
  end
end

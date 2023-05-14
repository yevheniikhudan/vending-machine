# frozen_string_literal: true

require './app/components/showcase'
require './spec/support/shared_examples/accountable'

RSpec.describe Showcase do
  subject(:showcase) { described_class.new(initiate_empty: true) }

  let(:accountable) { showcase }
  it_behaves_like 'accountable'

  describe '#available_products' do
    subject(:available_products) { showcase.available_products }

    before do
      [
        { id: 1 },
        { id: 1 },
        { id: 2 }
      ].each do |product|
        showcase.add(id: product[:id])
      end
    end

    it {
      expect(available_products.length).to eq(2)
      expect(available_products.first).to eq(
        { id: 1,
          name: 'Snickers',
          price: 150,
          count: 2 }
      )
    }
  end
end

require './spec/support/shared_examples/accountable'
require './app/components/cash_box'

RSpec.describe CashBox do
  subject(:cash_box) { described_class.new(initiate_empty: true) }

  shared_context 'with cash box is not empty' do
    before do
      change_coins.each do |change_coin|
        cash_box.add(id: change_coin)
      end
    end
  end

  let(:accountable) { cash_box }
  it_behaves_like 'accountable'

  describe '#gather_change' do
    subject(:gather_change) { cash_box.gather_change(change_amount:) }

    context 'when exchange coins are empty' do
      let(:change_amount) { 100 }

      it { expect(gather_change).to eq([]) }
    end

    context 'when exchange coins sum less than exchange amount' do
      include_context 'with cash box is not empty'

      let(:change_coins) { [25] }
      let(:change_amount) { 100 }

      it { expect(gather_change).to eq([25]) }
    end

    context 'when exchange coins sum more than exchange amount' do
      include_context 'with cash box is not empty'

      let(:change_coins) { [50, 50, 200, 25] }
      let(:change_amount) { 100 }

      it { expect(gather_change).to eq([50, 50]) }
    end

    context 'when there are couple combinations to return exchange' do
      include_context 'with cash box is not empty'

      let(:change_coins) { [200, 50, 50, 50, 50, 50, 50, 25, 25, 25, 25] }
      let(:change_amount) { 300 }

      it 'returns minimum coins' do
        expect(gather_change).to eq([200, 50, 50])
      end
    end
  end
end

RSpec.shared_examples 'accountable' do
  let(:id) { 'dummy_id' }

  describe '#add' do
    subject(:add) { accountable.add(id:) }

    it {
      add
      expect(accountable.instance_variable_get(:@inventory)[id]).to eq(1)
    }
  end

  describe '#destroy' do
    subject(:remove) { accountable.destroy(id:) }

    before { accountable.add(id:) }

    it {
      remove
      expect(accountable.instance_variable_get(:@inventory)[id]).to eq(0)
    }
  end
end

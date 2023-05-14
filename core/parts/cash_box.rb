require './core/behaviors/accountable'

# CashBox class for managing coins
class CashBox
  include Accountable

  POSSIBLE_COINS = [
    { value: 25 },
    { value: 50 },
    { value: 100 },
    { value: 200 },
    { value: 300 },
    { value: 500 }
  ].freeze

  def initialize(initiate_empty: false)
    @inventory = Hash.new(0)
    fill_out_change unless initiate_empty
  end

  # Calculates the minimum number of coins needed to make up a given change amount
  # In case when the repository does not have enough change coins returns all that can be gathered
  #
  # @param [Integer] change_amount The amount of change to be gathered
  # @return [Array<Integer>] An array of coins sorted in descending order
  def gather_change(change_amount:)
    change_result = []
    @inventory.filter { |_, v| v.positive? }.keys.sort.reverse.each do |av_coin|
      break if change_amount.zero?

      available_count = @inventory[av_coin]
      count, = change_amount.divmod(av_coin)
      count = [available_count, count].min
      count.times { change_result.push(av_coin) }
      change_amount -= count * av_coin
    end
    change_result
  end

  private

  def fill_out_change
    POSSIBLE_COINS.each { |item| 2.times { add(id: item[:value]) } }
  end
end

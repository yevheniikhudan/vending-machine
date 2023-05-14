require './core/behaviors/accountable'

# Showcase class for managing products
class Showcase
  include Accountable

  POSSIBLE_PRODUCTS = [
    { id: 1, name: 'Snickers', price: 150 },
    { id: 2, name: 'Oreo', price: 900 },
    { id: 3, name: "M&M's", price: 200 },
    { id: 4, name: 'Cheetos', price: 75 },
    { id: 5, name: 'Coca cola', price: 225 },
    { id: 6, name: 'BonAqua', price: 200 }
  ].freeze

  def initialize(initiate_empty: false)
    @inventory = Hash.new(0)
    fill_out_products unless initiate_empty
  end

  # Returns an array of ProductRecord objects for all items in the inventory that have a positive count
  #
  # @return [Array<InventoryRecord>]
  def available_products
    POSSIBLE_PRODUCTS.filter_map do |item|
      count = count(item[:id])
      item.merge(count:) if count.positive?
    end
  end

  private

  def fill_out_products
    POSSIBLE_PRODUCTS.each { |item| 2.times { add(id: item[:id]) } }
  end
end

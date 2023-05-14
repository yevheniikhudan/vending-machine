# Accountable module that add inventory management functionality
module Accountable
  # Adds an item to the inventory
  def add(id:)
    @inventory[id] += 1
  end

  # Removes an item from the inventory
  def destroy(id:)
    return if @inventory[id].zero?

    @inventory[id] -= 1
  end

  private

  def count(id)
    @inventory[id]
  end
end

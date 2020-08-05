class Event

  attr_reader :name, :food_trucks

  def initialize(name)
    @name = name
    @food_trucks = []
  end

  def add_food_truck(truck)
    @food_trucks << truck
  end

  def food_truck_names
    @food_trucks.collect { |truck| truck.name }
  end

  def food_trucks_that_sell(item)
    @food_trucks.find_all do |truck|
      truck.check_stock(item) > 0
    end
  end

  def total_inventory
    @food_trucks.inject(Hash.new{ |hash, key| hash[key] = {quantity: 0, food_trucks: [] }}) do |inventory_hash, truck|
      truck.inventory.each do |item, quan|
        inventory_hash[item][:quantity] += quan
        inventory_hash[item][:food_trucks] << truck
      end
      inventory_hash
    end
  end

  def overstocked_items
    total_inventory.keys.find_all do |item|
      total_inventory[item][:food_trucks].size > 1 && total_inventory[item][:quantity] > 50
    end
  end

end

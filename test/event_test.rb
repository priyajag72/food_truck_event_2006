require "minitest/autorun"
require "minitest/pride"
require "mocha/minitest"
require "./lib/item"
require "./lib/food_truck"
require "./lib/event"

class EventTest < Minitest::Test

  def setup
    @item1 = Item.new({name: 'Peach Pie (Slice)', price: "$3.75"})
    @item2 = Item.new({name: 'Apple Pie (Slice)', price: '$2.50'})
    @item3 = Item.new({name: "Peach-Raspberry Nice Cream", price: "$5.30"})
    @item4 = Item.new({name: "Banana Nice Cream", price: "$4.25"})
    @item5 = Item.new({name: 'Onion Pie', price: '$25.00'})

    @food_truck1 = FoodTruck.new("Rocky Mountain Pies")
    @food_truck2 = FoodTruck.new("Ba-Nom-a-Nom")
    @food_truck3 = FoodTruck.new("Palisade Peach Shack")

    @event = Event.new("South Pearl Street Farmers Market")

    @food_truck1.stock(@item1, 35)
    @food_truck1.stock(@item2, 7)

    @food_truck2.stock(@item4, 50)
    @food_truck2.stock(@item3, 25)

    @food_truck3.stock(@item1, 65)
    @food_truck3.stock(@item3, 10)
  end

  def test_it_exists
    assert_instance_of Event, @event
  end

  def test_it_has_attributes
    assert_equal "South Pearl Street Farmers Market", @event.name
    assert_equal [], @event.food_trucks
  end

  def test_it_can_add_food_trucks
    @event.add_food_truck(@food_truck1)
    @event.add_food_truck(@food_truck2)
    @event.add_food_truck(@food_truck3)

    assert_equal [@food_truck1, @food_truck2, @food_truck3], @event.food_trucks
  end

  def test_it_can_call_food_truck_names
    @event.add_food_truck(@food_truck1)
    @event.add_food_truck(@food_truck2)
    @event.add_food_truck(@food_truck3)

    assert_equal ["Rocky Mountain Pies", "Ba-Nom-a-Nom", "Palisade Peach Shack"], @event.food_truck_names
  end

  def test_it_can_check_food_trucks_by_item
    @event.add_food_truck(@food_truck1)
    @event.add_food_truck(@food_truck2)
    @event.add_food_truck(@food_truck3)

    assert_equal [@food_truck1, @food_truck3], @event.food_trucks_that_sell(@item1)
    assert_equal [@food_truck2], @event.food_trucks_that_sell(@item4)
  end

  def test_it_can_call_total_inventory
    @event.add_food_truck(@food_truck1)
    @event.add_food_truck(@food_truck2)
    @event.add_food_truck(@food_truck3)

    assert_equal 50, @event.total_inventory[@item4][:quantity]
    assert_equal [@food_truck1, @food_truck3], @event.total_inventory[@item1][:food_trucks]
  end

  def test_it_can_check_overstocked_items
    @event.add_food_truck(@food_truck1)
    @event.add_food_truck(@food_truck2)
    @event.add_food_truck(@food_truck3)

    assert_equal [@item1], @event.overstocked_items
  end

  def test_it_can_sort_all_items_and_remove_duplicates
    @event.add_food_truck(@food_truck1)
    @event.add_food_truck(@food_truck2)
    @event.add_food_truck(@food_truck3)

    assert_equal ["Apple Pie (Slice)", "Banana Nice Cream", "Peach Pie (Slice)", "Peach-Raspberry Nice Cream"], @event.sorted_item_list
  end

  def test_it_can_create_a_date_for_event
    assert_equal Date.today.strftime("%e/%m/%Y"), @event.date
    # Date.stubs(:today).returns(2020-02-24)
    # assert_equal "24/02/2020", @event.date
  end

  def test_it_can_sell_items
    # Add a method to your Event class called sell that takes an item and a quantity as arguments. There are two possible outcomes of the sell method:
    #
    # If the Event does not have enough of the item in stock to satisfy the given quantity, this method should return false.
    #
    # If the Event's has enough of the item in stock to satisfy the given quantity, this method should return true. Additionally, this method should reduce the stock of the FoodTrucks. It should look through the FoodTrucks in the order they were added and sell the item from the first FoodTruck with that item in stock. If that FoodTruck does not have enough stock to satisfy the given quantity, the FoodTruck's entire stock of that item will be depleted, and the remaining quantity will be sold from the next food_truck with that item in stock. It will follow this pattern until the entire quantity requested has been sold.

    @event.add_food_truck(@food_truck1)
    @event.add_food_truck(@food_truck2)
    @event.add_food_truck(@food_truck3)

    assert_equal false, @event.sell(@item1, 200)
    assert_equal false, @event.sell(@item5, 1)
    assert_equal true, @event.sell(@item4, 5)
  end


end

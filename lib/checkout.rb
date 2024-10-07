require_relative 'discounts'

#refactoring changes:
#
# you can now access total from the Checkout instance without having to run calculations
# scan function replaced with add_items_to_basket for clarity
# basket is now a hash with items and counts instead of an array of items
#

class Checkout
  attr_reader :prices, :total
  private :prices

  def initialize(prices)
    @prices = prices
    @discounts = Discounts.new().item_discounts

    #adding an instance variable total here will allow us to get
    #the total without having to run the calculations each time
    @total = 0
  end

  #add item to basket
  #if item is already in basket +1 to the count
  def add_item_to_basket(item)
    item = item.to_sym

    if prices[item]
      basket[item] ? basket[item] += 1 : basket[item] = 1
    else
      raise "Item '#{item}' not found in the price menu, skipping item"
    end

    #Potential feature to bring up:
    #call calculate total each time we add item to basket

    #Pros:
    # if we have a basket widget, it will display real time prices
    #Const:
    # have to calculate total each time an item is added

    #potential alternative, call the calculation each time the widget is loaded/displayed.
  end

  #This is a large function which could be simplified by using Procs
  #(if we were to implement then in discounts.rb)
  # or I would consider moving it out into a separate file if we would have more discounts

  #Returns the cost of the items after calculating discounts
  def apply_discount(item,count)
    discount = @discounts[item]
    price_per_item = @prices[item]

    case discount[:type]

    #if discount is a multiBuy (buy x get y free)
    #calculate the number of items we have to pay for
    #ie if buy 3 get 1 free, then number of items to pay for will be 2

    #then get the remaining items and return the price for all of them combined
    when :multi_buy
      buy_amount = discount[:buy_amount]
      get_amount = discount[:get_amount]

      discounted_items = count / (buy_amount) * (buy_amount - get_amount)
      remaining_items = count % (buy_amount)

      price_per_item * (discounted_items + remaining_items )

    #If discount is a flat discount
    # check for a flat percentage, then apply that to all the amount of items
    # if it's a percentage only on the first item then apply it and calculate the
    # price for remaining items
    when :flat
      
      if discount[:percentage]
        percentage_discount = discount[:percentage] / 100.0
        price_per_item * count * (1 - percentage_discount)

      else
        first_item_discount = discount[:first_item_discount] / 100.0
        additional_item_discount = discount[:additional_item_discount] / 100.0 

        first_item_price = price_per_item * (1 - first_item_discount)

        if count > 1
          remaining_items_price = (count - 1) * price_per_item * (1 - additional_item_discount)
        else
          remaining_items_price = 0 
        end

        first_item_price + remaining_items_price
      end
    end
  end

  # returns the total cost of the basket
  def calculate_total
    @total = 0
    basket.each do |item, count|
      if @discounts[item]
        @total += apply_discount(item, count)

      else
        @total += prices.fetch(item) * count
      end
    end

    @total
  end

  private

  def basket
    @basket ||= Hash.new
  end
end

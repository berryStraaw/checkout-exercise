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

    #adding an instance variable total here will allow us to get
    #the total without having to run the calculations each time
    @total = 0
  end

  #add item to basket
  #if item is already in basket +1 to the count
  def add_item_to_basket(item)
    #TO-DO
    #add error catching on items without prices

    item = item.to_sym
    basket[item] ? basket[item] += 1 : basket[item] = 1

    #Potential feature to bring up:
    #call calculate total each time we add item to basket

    #Pros:
    # if we have a basket widget, it will display real time prices
    #Const:
    # have to calculate total each time an item is added

    #potential alternative, call the calculation each time the widget is loaded/displayed.
  end

  def calculate_total
    @total = 0
    basket.each do |item, count|
      #TO-DO
      #add dynamic discounts
      if item == :apple || item == :pear
        if (count % 2 == 0)
          @total += prices.fetch(item) * (count / 2)
        else
          @total += prices.fetch(item) * count
        end
      #TO-DO
      #add dynamic discounts
      elsif item == :banana || item == :pineapple
        if item == :pineapple
          @total += (prices.fetch(item) / 2)
          @total += (prices.fetch(item)) * (count - 1)
        else
          @total += (prices.fetch(item) / 2) * count
        end
      else
        @total += prices.fetch(item) * count
      end
    end

    @total
  end

  private

  def basket
    @basket || = Hash.new
  end
end

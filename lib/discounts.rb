class Discounts
  attr_reader :item_discounts

  #Potential to use procs depending on how discounts are fetched

  # One option would be to set up a function which takes discounts from a db and turns them into procs for an easier way of using them
  # Idealy I would discuss this with a senior dev before implementing.

  def initialize()
    @item_discounts = fetch_discounts
  end

  private

  def fetch_discounts
    #Example of a discount:
    # for banana, flat 50% off
    # for mangos, buy 3 get 1 free

    #Current limitations:
    # each type would have to follow the same structure, ie flat type will need to have a percentage
    {
      :apple => {
        :type => :multi_buy,
        :buy_amount => 2,
        :get_amount => 1,
      },
      :pear => {
        :type => :multi_buy,
        :buy_amount => 2,
        :get_amount => 1,
      },
      :pineapple => {
        :type => :flat,
        :first_item_discount => 50, 
        :additional_item_discount => 0,
      },
      :banana => {
        :type => :flat,
        :percentage => 50,
      },
      :mango => {
        :type => :multi_buy,
        :buy_amount => 3,
        :get_amount => 1,
      }
    }
  end

end


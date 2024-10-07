require 'spec_helper'
require 'checkout'

RSpec.describe Checkout do
  describe '#total' do
    subject(:total) { checkout.calculate_total }

    let(:checkout) { Checkout.new(pricing_rules) }
    let(:pricing_rules) {
      {
        apple: 10,
        orange: 20,
        pear: 15,
        banana: 30,
        pineapple: 100,
        mango: 200
      }
    }

    context 'when no offers apply' do
      before do
        checkout.add_item_to_basket(:apple)
        checkout.add_item_to_basket(:orange)
      end

      it 'returns the base price for the basket' do
        expect(total).to eq(30)
      end
    end

    context 'when a two for 1 applies on apples' do
      before do
        checkout.add_item_to_basket(:apple)
        checkout.add_item_to_basket(:apple)
      end

      it 'returns the discounted price for the basket' do
        expect(total).to eq(10)
      end

      context 'and there are other items' do
        before do
          checkout.add_item_to_basket(:orange)
        end

        it 'returns the correctly discounted price for the basket' do
          expect(total).to eq(30)
        end
      end
    end

    context 'when a two for 1 applies on pears' do
      before do
        checkout.add_item_to_basket(:pear)
        checkout.add_item_to_basket(:pear)
      end

      it 'returns the discounted price for the basket' do
        expect(total).to eq(15)
      end

      context 'and there are other discounted items' do
        before do
          checkout.add_item_to_basket(:banana)
        end

        it 'returns the correctly discounted price for the basket' do
          expect(total).to eq(30)
        end
      end
    end

    context 'when a half price offer applies on bananas' do
      before do
        checkout.add_item_to_basket(:banana)
      end

      it 'returns the discounted price for the basket' do
        expect(total).to eq(15)
      end
    end

    context 'when a half price offer applies on pineapples restricted to 1 per customer' do
      before do
        checkout.add_item_to_basket(:pineapple)
        checkout.add_item_to_basket(:pineapple)
      end

      it 'returns the discounted price for the basket' do
        expect(total).to eq(150)
      end
    end

    context 'when a buy 3 get 1 free offer applies to mangos' do
      before do
        4.times { checkout.add_item_to_basket(:mango) }
      end

      it 'returns the discounted price for the basket' do
        expect(total).to eq(600)
      end
    end

    context 'when adding an item without a price' do
      before do
        checkout.add_item_to_basket(:apple)
      end

      it 'raises an error when the item is not in the price list' do
        expect { checkout.add_item_to_basket(:car) }.to raise_error("Item 'car' not found in the price menu, skipping item")
      end

      it 'returns the price of items with a price' do
        expect(total).to eq(10)
      end
    end

  end
end

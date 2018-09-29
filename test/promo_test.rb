require 'test_helper'
require 'promo'

# Testing happy path
describe Promo, :attributes do
  it 'has necessary attributes' do
    %i[product_code type promo_price promo_amount].each do |attr|
      expect(Promo.new).must_respond_to attr
    end
  end
end

describe Promo, '2x1' do
  it "applies '2x1'" do
    checkout, promo = init_checkout(product_code: 'GR1', type: '2x1')
    2.times do
      checkout.scan(Item.new(code: 'GR1', name: 'Green Tea', price: 3.11))
    end

    promo.apply!(checkout)

    expect(checkout.total).must_equal 3.11
  end
end

describe Promo, :bulk_discount do
  it "applies 'bulk_discount' on 5 strawberries" do
    checkout = discount_strawberries(5)
    expect(checkout.total).must_equal 22.50 # 4,50 x 5 = 22,50
  end

  it "doesn't apply 'bulk_discount' on 1 strawberry" do
    checkout = discount_strawberries(2)
    expect(checkout.total).must_equal 10
  end

  it "applies 'bulk_discount' on 4 coffees" do
    checkout = discount_coffee(4)
    expect(checkout.total).must_equal 29.95
  end

  it "doesn't apply 'bulk_discount' on 2 coffees" do
    checkout = discount_coffee(2)
    expect(checkout.total).must_equal 22.46
  end
end

private

def init_checkout(pricing_rules)
  promo = Promo.new(pricing_rules)
  [Checkout.new(*promo), promo]
end

def discount_strawberries(many)
  checkout, promo = init_checkout(
    product_code: 'SR1', type: 'bulk_discount', promo_price: 4.50, promo_amount: 3
  )
  many.times { checkout.scan(Item.new(code: 'SR1', name: 'Strawberries', price: 5)) }
  promo.apply!(checkout)
  checkout
end

def discount_coffee(many)
  checkout, promo = init_checkout(
    product_code: 'CF1', type: 'bulk_discount', promo_amount: 3
  )
  many.times do
    checkout.scan(Item.new(code: 'CF1', name: 'Coffee', price: 11.23))
  end
  promo.apply!(checkout)
  checkout
end

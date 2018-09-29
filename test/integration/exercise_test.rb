require 'test_helper'
require 'promo'
require 'item'
require 'checkout'

describe 'exercise integration cases' do
  before do
    @checkout = Checkout.new(Promo.special_conditions)
    @gr1 = Item.new(code: 'GR1', name: 'Green Tea', price: 3.11)
    @sr1 = Item.new(code: 'SR1', name: 'Strawberries', price: 5)
    @cf1 = Item.new(code: 'CF1', name: 'Coffee', price: 11.23)
  end

  it 'Basket: GR1,SR1,GR1,GR1,CF1' do
    3.times { @checkout.scan(@gr1.clone) }
    @checkout.scan(@sr1)
    @checkout.scan(@cf1)

    expect(@checkout.total).must_equal 22.45
  end

  it 'Basket: GR1,GR1' do
    2.times { @checkout.scan(@gr1.clone) }

    expect(@checkout.total).must_equal 3.11
  end

  it 'Basket: SR1,SR1,GR1,SR1' do
    3.times { @checkout.scan(@sr1.clone) }
    @checkout.scan(@gr1)

    expect(@checkout.total).must_equal 16.61
  end

  it 'Basket: GR1,CF1,SR1,CF1,CF1' do
    3.times { @checkout.scan(@cf1.clone) }
    @checkout.scan(@sr1)
    @checkout.scan(@gr1)

    expect(@checkout.total).must_equal 30.57
  end
end
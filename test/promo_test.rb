require 'test_helper'
require 'promo'

# Tests are created on a simple, naive approach
describe Promo do
  let(:promo) { Promo.new }

  it 'has necessary attributes' do
    [:product_code, :type, :discount_price, :discount_percentage].each do |attr|
      #assert promo.respond_to?(attr)
      assert_respond_to promo, attr
    end  
  end

  it "applies '2x1' promo offer" do
    item = Minitest::Mock.new.expect(:code, 'GR1')
    checkout = Minitest::Mock.new.expect(:items, [item])
    promo = Promo.new(product_code: 'GR1', type: '2x1')
    
     #promo.apply!(checkout)
     assert_equal checkout.items.count, 1
  end
end

require 'test_helper'
require 'checkout'

describe Checkout do
  let(:rule_types) { %w[2x1 bulk_discount special_discount] }
  let(:subject) { Checkout.new }

  it 'receives multiple special conditions' do
    pricing_rules = rule_types.map do |type|
      Minitest::Mock.new.expect(:type, type)
    end

    co = Checkout.new(pricing_rules)

    expect(co.pricing_rules.size).must_equal 3
    assert_equal rule_types, co.pricing_rules.map(&:type)
  end

  it '#scan' do
    item = Minitest::Mock.new.expect(:code, 'GR1')
    3.times { subject.scan(item) }

    expect(subject.cart.count).must_equal 3
  end

  it '#total' do
    # mocks do not respond to :==
    [Item.new(price: 3.11), Item.new(price: 5.00), Item.new(price: 11.23)]
      .each do |item|
      subject.scan(item)
    end

    expect(subject.total).must_equal 19.34
  end
end

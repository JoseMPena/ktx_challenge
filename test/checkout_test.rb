require 'test_helper'
require 'checkout'

describe Checkout do
  let(:rule_types) { %w[2x1 bulk_discount special_discount] }
  let(:subject) { Checkout.new }

  it 'receives multiple promos' do
    pricing_rules = rule_types.map do |type|
      Minitest::Mock.new.expect(:type, type)
    end

    co = Checkout.new(pricing_rules)

    assert_equal co.pricing_rules.size, 3
    assert_equal rule_types, co.pricing_rules.map(&:type)
  end

  it '#scan' do
    item = Minitest::Mock.new.expect(:code, 'GR1')
    3.times { subject.scan(item) }

    assert_equal 3, subject.items.count
  end

  it '#total without promos' do
    [Minitest::Mock.new.expect(:price, 3.11),
     Minitest::Mock.new.expect(:price, 5.00),
     Minitest::Mock.new.expect(:price, 11.23)].each do |item|
      subject.scan(item)
    end

    assert_equal 19.34, subject.total
  end
end

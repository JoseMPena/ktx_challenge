class Checkout
  attr_reader :pricing_rules, :items

  def initialize(pricing_rules = [])
    @pricing_rules = pricing_rules
    @items = []
  end

  def scan(item)
    @items << item
  end

  def total
    @items.map(&:price).reduce(:+)
  end
end

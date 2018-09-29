class Checkout
  attr_reader :pricing_rules, :cart

  def initialize(*pricing_rules)
    @pricing_rules = pricing_rules.flatten
    @cart = []
  end

  def scan(item)
    @cart << item
    @cart.include? item
  end

  def total
    apply_promos
    dirty_total = @cart.map(&:price).reduce(:+)
    dirty_total.round(2)
  end

  def apply_promos
    pricing_rules.reject(&:used).each { |promo| promo.apply!(self) }
  end
end

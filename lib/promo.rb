class Promo
  # Special conditions in exercise for CEO, COO, CTO
  ::PROMO_TYPES = [
    { product_code: 'GR1', type: '2x1' },
    { product_code: 'SR1', type: 'bulk_discount', promo_price: 4.50, promo_amount: 3 },
    { product_code: 'CF1', type: 'bulk_discount', promo_amount: 3 }
  ].freeze

  attr_accessor :product_code, :type, :promo_price, :promo_amount, :used

  def initialize(**attrs)
    attrs.each_pair do |k, v|
      send("#{k}=", v) if respond_to?(k)
    end
    @promo_amount ||= 0
    @used = false
  end

  # quickly initialize the conditions for this exercise
  def self.special_conditions
    conditions = []
    PROMO_TYPES.each do |type|
      conditions << new(type)
    end
    conditions
  end

  def apply!(checkout)
    items = promo_items(checkout)
    return if items.count < 2 || items.count < promo_amount

    # this will do fine for this amount of types, for scalability we should come with another solution.
    self.used = case type
                when '2x1'
                  apply_2x1(items)
                when 'bulk_discount'
                  apply_bulk_discount(items)
                end
  end

  # ??
  def apply_2x1(items)
    free_items = items.take(items.count / 2)
    free_items.each { |item| item.price = 0 }
  end

  def apply_bulk_discount(items)
    # promo_items.update_all
    items.each do |item|
      item.price = promo_price || ((item.price.to_f / 3.0) * 2)
    end
  end

  def promo_items(checkout)
    checkout.cart.select { |item| item.code == product_code }
  end
end

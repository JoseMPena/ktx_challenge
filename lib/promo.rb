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
    return unless promo_items(checkout).any?

    # this will do fine for this amount of types, for scalability we should come with another solution.
    self.used = case type
                when '2x1'
                  apply_2x1(checkout)
                when 'bulk_discount'
                  apply_bulk_discount(checkout)
                end
  end

  # really??
  def apply_2x1(checkout)
    items = promo_items(checkout)
    return unless items.count > 1
    free_items = items.take(items.count / 2)
    result = []
    free_items.each { |item| item.price = 0 }
    result.reduce { |a, b| a && b }
  end

  def apply_bulk_discount(checkout)
    items = promo_items(checkout)
    return unless items.count >= promo_amount
    # promo_items.update_all
    items.each do |item|
      item.price = promo_price || ((item.price.to_f / 3.0) * 2)
    end
  end

  def promo_items(checkout)
    checkout.cart.select { |item| item.code == product_code }
  end
end

class Promo
  attr_accessor :product_code, :type, :discount_price, :discount_percentage

  def initialize(**attrs)
    attrs.each_pair do |k, v|
      send("#{k}=", v)
    end
  end
end

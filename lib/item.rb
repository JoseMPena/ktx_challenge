class Item
  attr_accessor :code, :name, :price

  def initialize(**attrs)
    @code = attrs[:code]
    @name = attrs[:name]
    @price = attrs[:price]
  end
end

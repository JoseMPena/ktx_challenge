require 'test_helper'
require 'item'

describe Item do

  it 'has required attributes' do
    item = Item.new
    [:code, :name, :price].each do |attr|
      assert item.respond_to?(attr)
    end    
  end
end

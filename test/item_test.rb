require 'test_helper'
require 'item'

describe Item do
  it 'has required attributes' do
    item = Item.new
    %i[code name price].each do |attr|
      expect(item).must_respond_to attr
    end
  end
end

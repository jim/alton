require 'example_helper'

describe "Ingredient math" do

  before(:all) do
    @cup = Alton::Unit(:cup)
  end
  
  it "can add ingredients with simple units" do
    one = Alton::Ingredient.new('water', Alton::Amount.new(1, @cup))
    half = Alton::Ingredient.new('water', Alton::Amount.new(0.5, @cup))
    one_and_a_half = one + half
    one_and_a_half.name.should eql("water")
    one_and_a_half.amount.quantity.should eql(1.5)
    one_and_a_half.amount.unit.should eql(@cup)
  end
  
end
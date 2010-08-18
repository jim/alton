require 'example_helper'

describe "Ingredient math" do

  before(:all) do
    @cup = Alton::Unit(:cup)
    @one_cup = Alton::Amount.new(1, @cup)    
  end
  
  it "can add ingredients with simple units" do
    some_h20 = Alton::Ingredient.new('water', @one_cup)
    more_h20 = Alton::Ingredient.new('water', @one_cup)
    combined = some_h20 + more_h20
    combined.name.should eql("water")
    combined.amount.quantity.should eql(2)
    combined.amount.unit.should eql(@cup)
  end
  
  it "raises an exception when ingredient names do not match" do
    h20 = Alton::Ingredient.new('vinegar', @one_cup)
    oil = Alton::Ingredient.new('oil', @one_cup)

    proc {
      salad_dressing = h20 + oil
    }.should raise_error(Alton::IngredientMismatch)
  end
  
end
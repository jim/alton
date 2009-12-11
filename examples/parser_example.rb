require 'example_helper'

def should_parse(ingredient, quantity, unit, name, options={})
  it "parses '#{ingredient}'", options do
    result = Alton::Ingredient::parse_text(ingredient)
    result.name.should eql(name)
    result.amount.unit.key.should eql(unit)
    result.amount.quantity.should eql(quantity)
  end
end

describe "Ingredient parsing" do

  describe "tablespoon" do

    should_parse '1 tablespoon olive oil', 
      1, :tablespoon, 'olive oil'
    
    should_parse '1 T olive oil', 
      1, :tablespoon, 'olive oil'
    
    should_parse '1 tbsp olive oil', 
      1, :tablespoon, 'olive oil'
      
  end

  describe "teaspoon" do
    
    should_parse '1 teaspoon ground cumin',
      1, :teaspoon, "ground cumin"

    should_parse '1 t ground cumin',
      1, :teaspoon, 'ground cumin'
      
    should_parse '1 tsp ground cumin',
      1, :teaspoon, 'ground cumin'
    
  end

  describe "cup" do
    
    should_parse '1 cup fresh smooth peanut butter', 
      1, :cup, 'fresh smooth peanut butter'

    should_parse '1 C fresh smooth peanut butter', 
      1, :cup, 'fresh smooth peanut butter'

    should_parse '1 c fresh smooth peanut butter', 
      1, :cup, 'fresh smooth peanut butter'
    
  end

  describe "plural units" do
    
    should_parse '2 tablespoons olive oil', 
      2, :tablespoon, 'olive oil'
    
  end
  
  describe "perioud after abbreviation" do
    
    should_parse '2 tsp. olive oil', 
      2, :teaspoon, 'olive oil'
    
  end

  describe "odd units" do
    
    should_parse '2 cloves garlic, finely minced and mashed',
      2, :clove, 'garlic, finely minced and mashed'

  end

end

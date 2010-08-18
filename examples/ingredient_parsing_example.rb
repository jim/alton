require 'example_helper'

def ingredient_should_match(ingredient, quantity, unit, name)
  ingredient.name.should eql(name)
  ingredient.amount.unit.key.should eql(unit)
  ingredient.amount.quantity.should eql(quantity)
end

def parses_ingredient(text, quantity, unit, name, options={})
  it "parses '#{text}'", options do
    ingredient = Alton::Ingredient::parse_text(text)
    ingredient_should_match(ingredient, quantity, unit, name)
  end
end

def parses_ingredients_block(text, expected_array, options={})
  it "parses #{text}", options do
    lines = text.split("\n")
    Alton::Ingredient::parse_block(text).each_with_index do |result, index|
      ingredient_should_match(result, *expected_array[index])
    end    
  end
end

describe "Ingredient parsing" do

  describe "tablespoon" do

    parses_ingredient '1 tablespoon olive oil', 
      1, :tablespoon, 'olive oil'
    
    parses_ingredient '1 T olive oil', 
      1, :tablespoon, 'olive oil'
    
    parses_ingredient '1 tbsp olive oil', 
      1, :tablespoon, 'olive oil'
      
  end

  describe "teaspoon" do
    
    parses_ingredient '1 teaspoon ground cumin',
      1, :teaspoon, "ground cumin"

    parses_ingredient '1 t ground cumin',
      1, :teaspoon, 'ground cumin'
      
    parses_ingredient '1 tsp ground cumin',
      1, :teaspoon, 'ground cumin'
    
  end

  describe "cup" do
    
    parses_ingredient '1 cup fresh smooth peanut butter', 
      1, :cup, 'fresh smooth peanut butter'

    parses_ingredient '1 C fresh smooth peanut butter', 
      1, :cup, 'fresh smooth peanut butter'

    parses_ingredient '1 c fresh smooth peanut butter', 
      1, :cup, 'fresh smooth peanut butter'
    
  end

  describe "plural units" do
    
    parses_ingredient '2 tablespoons olive oil', 
      2, :tablespoon, 'olive oil'
    
  end
  
  describe 'fractional quantities' do
    
    parses_ingredient '3/4 C AP flour',
      Rational(3,4), :cup, 'ap flour'
    
  end
  
  describe "period after abbreviation" do
    
    parses_ingredient '2 tsp. olive oil', 
      2, :teaspoon, 'olive oil'
    
  end

  describe "odd units" do
    
    parses_ingredient '2 cloves garlic, finely minced and mashed',
      2, :clove, 'garlic, finely minced and mashed'

  end

  describe "blocks" do
    
    ingredients = <<-NOM
1 tsp. vanilla extract
3 cups confectioner's sugar
2 tbs. milk
1/2 cup butter
1/2 cup vegetable shortening
NOM
      
    parses_ingredients_block ingredients, [
      [1, :teaspoon, 'vanilla extract'],
      [3, :cup, "confectioner's sugar"],
      [2, :tablespoon, 'milk'],
      [Rational(1,2), :cup, 'butter'],
      [Rational(1,2), :cup, 'vegetable shortening']]
    
  end

end

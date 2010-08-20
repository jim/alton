require 'example_helper'

def ingredient_should_match(ingredient, quantity, unit, name, options={})
  ingredient.name.should eql(name)
  ingredient.amount.unit.key.should eql(unit)
  ingredient.amount.quantity.should eql(quantity)
  options.each_pair do |key, value|
    next if key == :focused
    ingredient.notes[key].should eql(value)
  end
end

def parses_ingredient(text, quantity, unit, name, options={})
  it "parses ingredient '#{text}'", options do
    ingredient = Alton::Ingredient::parse_text(text)
    ingredient_should_match(ingredient, quantity, unit, name, options)
  end
end

def parses_ingredients_block(text, expected_array, options={})
  it "parses ingredients '#{text}'", options do
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
      2, :clove, 'garlic', :food => 'finely minced and mashed'

  end

  describe "blocks" do
    
    basic_ingredients = <<NOM
1 tsp. vanilla extract
3 cups confectioner's sugar
2 tbs. milk
1/2 cup butter
1/2 cup vegetable shortening
NOM
      
    parses_ingredients_block basic_ingredients, [
      [1, :teaspoon, 'vanilla extract'],
      [3, :cup, "confectioner's sugar"],
      [2, :tablespoon, 'milk'],
      [Rational(1,2), :cup, 'butter'],
      [Rational(1,2), :cup, 'vegetable shortening']]
    
  end

  describe "tacos stolen from allrecipes.com" do
    
    parses_ingredient '1 pound lean ground beef',
      1, :pound, 'lean ground beef'
      
    parses_ingredient '1 onion, diced',
      1, :object, 'onion', :food => 'diced'
      
    parses_ingredient '1/2 cup ketchup',
      Rational(1,2), :cup, 'ketchup'
    
    parses_ingredient '2/3 cup cold water',
      Rational(2,3), :cup, 'cold water'
    
    parses_ingredient '1 bunch cilantro, chopped',
      1, :bunch, 'cilantro', :food => 'chopped'
      
    parses_ingredient '1 garlic clove, minced',
      1, :object, 'garlic clove', :food => 'minced'
    
    parses_ingredient '2 limes, cut in wedges',
      2, :object, 'limes', :food => 'cut into wedges'
    
    parses_ingredient '1 cup dried lentils, rinsed',
      1, :cup, 'dried lentils', :food => 'rinsed'
    
    parses_ingredient '1 1/2 teaspoons salt, or to taste',
      Rational(3,2), :teaspoon, 'salt', :food => 'or to taste'
    
    parses_ingredient '12 taco shells',
      12, :object, 'taco shells'
    
    parses_ingredient '1 (4 pound) frozen rump roast',
      4, :pound, 'frozen rump roast'

    parses_ingredient '8 (7 inch) flour tortillas, warmed',
      8, :object, 'tortilla', :size => '7 inch', :food => 'warmed'

    parses_ingredient '1 (1.25 ounce) package taco seasoning mix',
      1.25, :ounce, 'taco seasoning mix', :package => '1.25 ounce package', :count => 1
    
    parses_ingredient '2 (4 ounce) cans diced green chilies, drained',
      8, :ounces, 'diced green chiles', :food => 'drained', :count => 2, :package => '4 ounce cans'
   
    # parses_ingredient 'salt and pepper to taste'
    
  end

end
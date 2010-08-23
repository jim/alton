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
      2, :clove, 'garlic', :prep => 'finely minced and mashed'

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
      1, :object, 'onion', :prep => 'diced'
      
    parses_ingredient '1/2 cup ketchup',
      Rational(1,2), :cup, 'ketchup'
    
    parses_ingredient '2/3 cup cold water',
      Rational(2,3), :cup, 'cold water'
    
    parses_ingredient '1 bunch cilantro, chopped',
      1, :bunch, 'cilantro', :prep => 'chopped'
      
    parses_ingredient '1 garlic clove, minced',
      1, :object, 'garlic clove', :prep => 'minced'
    
    parses_ingredient '2 limes, cut in wedges',
      2, :object, 'limes', :prep => 'cut in wedges'
    
    parses_ingredient '1 cup dried lentils, rinsed',
      1, :cup, 'dried lentils', :prep => 'rinsed'
    
    parses_ingredient '1 1/2 teaspoons salt, or to taste',
      Rational(3,2), :teaspoon, 'salt', :prep => 'or to taste'
    
    parses_ingredient '12 taco shells',
      12, :object, 'taco shells'
    
    parses_ingredient '1 (4 pound) frozen rump roast',
      4, :pound, 'frozen rump roast', :count => 1

    parses_ingredient '8 (7 inch) flour tortillas, warmed',
      8, :object, 'tortilla', :size => '7 inch', :prep => 'warmed'

    parses_ingredient '1 (1.25 ounce) package taco seasoning mix',
      1.25, :ounce, 'taco seasoning mix', :package => '1.25 ounce package', :count => 1
    
    parses_ingredient '2 (4 ounce) cans diced green chiles, drained',
      8, :ounce, 'diced green chiles', :prep => 'drained', :count => 2, :package => '4 ounce can'
   
    # parses_ingredient 'salt and pepper to taste'
    
  end

  describe "stolen from cooksillustrated.com" do
    
    parses_ingredient '1  24-ounce jar roasted red peppers, rinsed, patted dry, and cut into 1/2-inch dice (about 1 1/2 cups)',
      24, :ounce, 'roasted red peppers', :package => '24 ounce jar', :count => 1,
      :prep => 'rinsed, patted dry, and cut into 1/2-inch dice (about 1 1/2 cups)'
    
    # parses_ingredient 'medium garlic clove, minced or pressed through garlic press (about 1 teaspoon)'
    # '1 loaf country bread with thick crust (about 10 by 5 inches, ends discarded), sliced crosswise into into 3/4-inch-thick pieces'
   # '1 1/2 pounds carrots (about 8 medium), peeled and sliced 1/2 inch thick'
   # '1 recipe Toasted Bread for Bruschetta (see related recipe)'
    
  end

end
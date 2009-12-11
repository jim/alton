require 'example_helper'

def should_parse(ingredient, quantity, unit, name)
  it "parses '#{ingredient}'" do
    result = Alton::Ingredient::parse_text(ingredient)
    result.name.should eql(name)
    result.amount.unit.key.should eql(unit)
    result.amount.quantity.should eql(quantity)
  end
end

describe "Ingredient parsing" do

  should_parse '1 tablespoon olive oil', 
    1, :tablespoon, 'olive oil'
    
  should_parse '1 cup fresh smooth peanut butter', 
    1, :cup, 'fresh smooth peanut butter'

  should_parse '1/2 cup hot water', 
    0.5, :cup, 'hot water'

  should_parse '2 cloves garlic, finely minced and mashed',
    2, :clove, 'garlic, finely minced and mashed'
  
  should_parse '2 Tablespoons soy sauce',
    2, :tablespoon, 'soy sauce'
  
  should_parse '1 teaspoon ground cumin',
    1, :teaspoon, "ground cumin"
  
  should_parse '1/4 teaspoon cayenne powder',
    0.25, :teaspoon, 'cayenne powder'
    
  should_parse '1/2 teaspoon curry powder',
    0.5, :teaspoon, 'curry powder'

  should_parse '1/4 tsp coriander',
    0.25, :teaspoon, 'coriander'

  should_parse '1 teaspoon fresh lemon juice',
    1, :teaspoon, 'fresh lemon juice'

end

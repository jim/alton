require 'example_helper'

# def ingredient_should_match(ingredient, quantity, unit, name)
#   ingredient.name.should eql(name)
#   ingredient.amount.unit.key.should eql(unit)
#   ingredient.amount.quantity.should eql(quantity)
# end
# 
# def parses_ingredient(text, quantity, unit, name, options={})
#   it "parses '#{text}'", options do
#     ingredient = Alton::Ingredient::parse_text(text)
#     ingredient_should_match(ingredient, quantity, unit, name)
#   end
# end

def parses_steps_block(text, expected_array, options={})
  it "parses steps '#{text}'", options do
    lines = text.split("\n")
    Alton::Step::parse_block(text).each_with_index do |result, index|
      result.should eql(expected_array[index].first)
    end    
  end
end

describe "Steps parsing" do
  
  single_line_numbered_lists = <<NOM
1. In a large bowl, cream vegetable shortening and butter.
2. Add vanilla.
3. While mixing, slowly add confectioner's sugar.
4. While mixing, add milk.
5. Put in fridge after use.
NOM
  
  parses_steps_block single_line_numbered_lists, [
    ['In a large bowl, cream vegetable shortening and butter.'],
    ['Add vanilla.'],
    ["While mixing, slowly add confectioner's sugar."],
    ['While mixing, add milk.'],
    ['Put in fridge after use.']
  ]
  
end

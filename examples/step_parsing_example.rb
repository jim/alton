require 'example_helper'

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
  
  single_line_plain_lists = <<NOM
In a large bowl, cream vegetable shortening and butter.
Add vanilla.
NOM
  
  parses_steps_block single_line_plain_lists, [
    ['In a large bowl, cream vegetable shortening and butter.'],
    ['Add vanilla.'],
  ]
  
end

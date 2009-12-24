require 'example_helper'

def parses(text, numerator, denominator, options={})
  it "parses '#{text}'", options do
    result = Alton::Amount::parse_quantity(text)
    result.class.should eql(Rational)
    result.numerator.should eql(numerator)
    result.denominator.should eql(denominator)
  end
end

describe "Amount" do
  parses '1/2', 1, 2
  parses '4/2', 2, 1
  parses '6/7', 6, 7
  parses '1 3/4', 7, 4
  parses '3 4/3', 13, 3
end
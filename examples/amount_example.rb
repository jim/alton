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
  
  describe "basic math" do
    
    before(:all) do
      @cup = Alton::Unit(:cup)
      @one = Alton::Amount.new(1, @cup)
      @half = Alton::Amount.new(0.5, @cup)
      @third = Alton::Amount.new(Rational(1,3), @cup)
    end
    
    it "adds integers and decimals" do
      one_and_a_half = @one + @half
      one_and_a_half.quantity.should eql(1.5)
      one_and_a_half.unit.should eql(@cup)
    end
    
    it "adds rationals and integers" do
      one_and_a_third = @one + @third
      one_and_a_third.quantity.should eql(Rational(4,3))
      one_and_a_third.unit.should eql(@cup)
    end
    
  end
  
end
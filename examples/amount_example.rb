require 'example_helper'

def parses_fraction(text, numerator, denominator, options={})
  it "parses fraction '#{text}'", options do
    result = Alton::Amount::parse_quantity(text)
    result.class.should eql(Rational)
    result.numerator.should eql(numerator)
    result.denominator.should eql(denominator)
  end
end

describe "Amount" do
  
  parses_fraction '1/2', 1, 2
  parses_fraction '4/2', 2, 1
  parses_fraction '6/7', 6, 7
  parses_fraction '1 3/4', 7, 4
  parses_fraction '3 4/3', 13, 3
  
  it "parses decimals" do
    result = Alton::Amount::parse_quantity('1.25')
    result.class.should eql(Float)
    result.should eql(1.25)
  end
  
  it "does not modify numeric values" do
    Alton::Amount::parse_quantity(1).should eql(1)
    Alton::Amount::parse_quantity(1.5).should eql(1.5)
    Alton::Amount::parse_quantity(Rational(3,4)).should eql(Rational(3,4))
  end
  
  
  describe "basic math" do
    
    before(:all) do
      @cup = Alton::Unit(:cup)
      @pint = Alton::Unit(:pint)
      @one_cup = Alton::Amount.new(1, @cup)
      @half_cup = Alton::Amount.new(0.5, @cup)
      @third_cup = Alton::Amount.new(Rational(1,3), @cup)
      @two_pints = Alton::Amount.new(2, @pint)
    end
    
    it "adds integers and decimals" do
      one_and_a_half = @one_cup + @half_cup
      one_and_a_half.quantity.should eql(1.5)
      one_and_a_half.unit.should eql(@cup)
    end
    
    it "adds rationals and integers" do
      one_and_a_third = @one_cup + @third_cup
      one_and_a_third.quantity.should eql(Rational(4,3))
      one_and_a_third.unit.should eql(@cup)
    end
    
    it "adds amount with different units" do
      two_and_a_half_pints = @one_cup + @two_pints
      two_and_a_half_pints.quantity.should eql(2.5)
      two_and_a_half_pints.unit.should eql(@pint)
    end
    
  end
  
  describe "converting between units" do
    it "converts to cups using a plural symbol name" do
      two_pints = Alton::Amount.new(2, Alton::Unit(:pint))
      two_pints.in(:cups).should eql(Alton::Amount.new(4, Alton::Unit(:cup)))
    end
    
    it "converts to cups using a singular symbol name" do
      two_pints = Alton::Amount.new(2, Alton::Unit(:pint))
      two_pints.in(:cup).should eql(Alton::Amount.new(4, Alton::Unit(:cup)))
    end
    
    it "converts to cups using a unit instance" do
      two_pints = Alton::Amount.new(2, Alton::Unit(:pint))
      two_pints.in(Alton::Unit(:cup)).should eql(Alton::Amount.new(4, Alton::Unit(:cup)))
    end
    
  end
  
  describe "equality testing" do
    it "is equal" do
      cup = Alton::Unit(:cup)
      Alton::Amount.new(3, cup).should eql(Alton::Amount.new(3, cup))
    end
  end
  
end
require 'example_helper'

describe "Rational numbers" do

  it "converts rational numbers to human friendly formats" do
    Rational(3,5).to_human.should eql('3/5')
    Rational(6,4).to_human.should eql('1 1/2')
  end

end
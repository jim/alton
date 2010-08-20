require 'example_helper'

describe "Unit" do

  describe "conversions" do
    it "knows how many fluid ounces it is" do
      Alton::Unit(:cup).fl_oz.should == 8
      Alton::Unit(:pint).fl_oz.should == 16
    end
  end

end
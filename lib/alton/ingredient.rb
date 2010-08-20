module Alton
  
  class IngredientMismatch < StandardError; end
  
  class Ingredient
    attr_accessor :name, :amount, :notes
  
    def initialize(name, amount)
      @name = name
      @amount = amount
      @notes = {}
    end
  
    class UnparseableIngredient < StandardError; end
    class UnsupportedUnit < StandardError; end
    
    # Parses an ingredient block into an array of Ingredients
    #
    # Splits input on newlines, and then runs each through parse_text.
    # 
    # @param [String] text to process
    # @return [Array] Collections of resulting Alton::Ingredient objects
    def self.parse_block(text)
      text.split("\n").map do |line|
        self.parse_text(line)
      end
    end
    
    # Parses an ingredient line into an Ingredient
    #
    # @param [String] text to process
    # @return [Alton::Ingredient] Object representation
    def self.parse_text(text)

      determine_quantity = lambda do |text|
        Alton::Amount.parse_quantity(text)
      end
      
      determine_unit = lambda do |text|
        match = Alton.units.find do |unit|
          unit.match?(text)
        end
        return match if match
        raise UnsupportedUnit.new("unit not supported: '#{text}'")
      end

      units = Alton.units.map do |unit|
        unit.abbreviations.keys << unit.name
      end.flatten.map{|k|k.downcase}.uniq.join('|')

      regex = %r{(.+)\s+(#{units})s?\.?\s+(.+)}

      if text.downcase =~ regex
        quantity, unit, name = $1, $2, $3
        unit = text.match(/\s(#{unit})s?\.?\s/i)[1]
        amount = Amount.new(determine_quantity.call(quantity), determine_unit.call(unit))
        self.new(name, amount)
      else
        raise UnparseableIngredient.new("could not parse '#{text}'")
      end
    end
    
    # Combines two Ingredient objects
    #
    # @raise [Alton::IngredientMismatch] if ingredients have different names
    # @param [Alton::Ingredient] ingredient to add
    # @return [Alton::Ingredient] new Alton::Ingredient with a summed amount
    def +(other)
      raise IngredientMismatch unless self.name == other.name
      self.class.new(self.name, self.amount + other.amount)
    end
  
  end
end

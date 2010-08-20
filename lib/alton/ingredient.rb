module Alton

  PACKAGES = %w{bag bottle box can container package jar}
  
  class UnparseableIngredient < StandardError; end
  class UnsupportedUnit < StandardError; end
  
  class IngredientMismatch < StandardError; end
    
  class Ingredient
    attr_accessor :name, :amount, :notes
  
    def initialize(name, amount)
      @name = name
      @amount = amount
      @notes = {}
    end
    
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
        return Alton::Unit(:object) if text.nil?
        match = Alton.units.find do |unit|
          unit.match?(text)
        end
        return match if match
        raise UnsupportedUnit.new("unit not supported: '#{text}'")
      end

      units = Alton.units.map do |unit|
        unit.abbreviations.keys << unit.name
      end.flatten.map{|k|k.downcase}.uniq.join('|')

      units_regex = %r{(.+)\s+(#{units})s?\.?\s+(.+)}
      whole_item_regex = %r{^([0-9/\s])\s+([^,]*),?\s+(.*)$}
        
      notes = {}
        
      if text.downcase =~ units_regex
        quantity, unit, name = $1, $2, $3
        unit = text.match(/\s(#{unit})s?\.?\s/i)[1]
      elsif text.downcase =~ whole_item_regex
        # assume we don't have a unit
        puts
        puts $1
        puts $2
        puts $3
        quantity, unit, name = $1, nil, $2
        notes[:food] = $3 if $3
      else
        raise UnparseableIngredient.new("could not parse '#{text}'")
      end
        amount = Amount.new(determine_quantity.call(quantity), determine_unit.call(unit))
        ingredient = self.new(name, amount)
        ingredient.notes[:food] = $4 unless $4.nil?
        ingredient
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

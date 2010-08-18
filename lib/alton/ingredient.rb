module Alton
  class Ingredient < Struct.new(:name, :amount)
  
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
        # case text
        #   when /(\d+) (\d)\/(\d+)/
        #     $1.to_i + ($2.to_f / $3.to_i)
        #   when /(\d+)\/(\d+)/
        #     $1.to_f / $2.to_i
        #   else
        #     text.to_i
        #   end
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
  
  end
end

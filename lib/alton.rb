module Alton
  
  class Ingredient < Struct.new(:name, :unit, :quantity)
    
    class UnparseableIngredient < StandardError; end
    
    # Parses an ingredient line into a standadized hash 
    #
    # @param [String] text to process
    # @return [Hash] hash representation
    def self.parse_text(text)
      units = 'C|c|cup|t|tsp|teaspoon|tablespoon|Tablespoon|clove'
      
      regex = %r{(.+)\s+(#{units})s?\.?\s+(.+)}
      if text =~ regex
        self.new($3, $2, $1)
      else
        raise UnparseableIngredient.new("could not parse '#{text}'")
      end
    end
    
  end
  
end
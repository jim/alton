module Alton

  class << self
    attr_accessor :debug
  end
  self.debug = false

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

      packages = PACKAGES.join('|')

      packaged_regex = %r{(.+)\s+\(?([\d\.\s]+?)[-\s]*(#{units})\)?s?\.?\s*(#{packages})s?\s*([^,]*),?\s*(.*)?}
      units_regex = %r{(.+)\s+(#{units})s?\.?\s+([^,]*),?\s*(.*)?}
      whole_object_regex = %r{([0-9/\s]+)\s+([^,]*),?\s*(.*)?}
        
      notes = {}        
      lowercase_text = text.downcase
        
      if lowercase_text =~ packaged_regex
        puts 'using packages' if Alton.debug
        
        match, raw_count, raw_quantity, unit, package, name, prep = $~.to_a
        count = determine_quantity.call(raw_count)
        quantity = determine_quantity.call(raw_quantity) * count
        notes[:count] = count
        notes[:package] = "#{raw_quantity} #{unit} #{package}"
        notes[:prep] = prep if prep
      elsif lowercase_text =~ units_regex
        puts 'using units' if Alton.debug
        
        match, quantity, unit, name, prep = $~.to_a
        notes[:prep] = prep if prep
        unit = text.match(/\s(#{unit})s?\.?\s/i)[1]
      elsif lowercase_text =~ whole_object_regex
        puts 'using using whole item' if Alton.debug
        
        match, quantity, name, prep = $~.to_a
        unit = nil
        notes[:prep] = prep if prep
      else
        raise UnparseableIngredient.new("could not parse '#{text}'")
      end
      amount = Amount.new(determine_quantity.call(quantity), determine_unit.call(unit))
      ingredient = self.new(name, amount)
      ingredient.notes = notes
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

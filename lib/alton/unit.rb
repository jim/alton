module Alton

  class << self
    attr_accessor :units
  end
  @units = []

  # Convenience method for retrieving a Alton::Unit instance by name or abbreviation
  #
  # @param [String, Symbol] name name or abbreviation for requested unit
  # @return [Alton::Unit] when a matching unit is found
  # @return [nil] when no matching unit is found
  def self.Unit(name)
    Alton.units.find {|u|u.match?(name.to_s)}
  end
  
  class Unit
    attr :abbreviations
    attr :name
    
    def initialize(name)
      Alton.units << self
      @name = name.to_s
      @abbreviations = {}
    end
    
    def key
      @name.to_sym
    end
    
    def match?(abbreviation)
      return true if abbreviation == @name
      @abbreviations.each_pair do |abbr, options|
        return true if abbreviation == abbr ||
                       (abbreviation.downcase == abbr.downcase && !options[:case_sensitive] == true)
      end
      false
    end
    
    def to_s
      name
    end

    module Proxy
      def self.unit(name, &block)
        b = Builder.new(name)
        b.instance_exec(&block) if block_given?
      end
      def self.run(&block)
        self.instance_exec(&block)
      end
    end
    
    class Builder
      def initialize(name)
        @unit = Unit.new(name)
      end
      def abbreviated(name, options={})
        @unit.abbreviations[name] = options
      end
      def volume(quantity, unit)
        @unit.instance_eval "def #{unit}; #{quantity}; end"
      end
      alias weight volume
    end

    def self.define(&block)
      Proxy.run(&block)
    end
    
  end
  
end
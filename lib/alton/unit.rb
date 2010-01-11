module Alton

  class << self
    attr_accessor :units
  end
  @units = []
  
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
      def volume(*args)
      end
    end

    def self.define(&block)
      Proxy.run(&block)
    end
    
  end
end

Alton::Unit.define do

  unit(:teaspoon) do
    abbreviated 't', :case_sensitive => true
    abbreviated 'tsp'
    volume '1/6', :fl_oz
    volume 4.93, :ml
  end
  
  unit :tablespoon do
    abbreviated 'T', :case_sensitive => true
    abbreviated 'tbs'
    abbreviated 'tbsp'
    volume '1/2', :fl_oz
    volume 14.79, :ml
  end
  
  unit :cup do
    abbreviated 'c'
    abbreviated 'C'
    volume 8, :fl_oz
    volume 236.59, :ml
  end
  
  unit :pint do
    abbreviated 'pt'
    volume 16, :fl_oz
    volume 473.18, :ml
  end
  
  unit :quart do
    abbreviated 'qt'
    volume 32, :fl_oz
    volume 946.35, :ml
  end
  
  unit :gallon do
    volume 128, :fl_oz
    volume 3785.41, :ml
  end

  unit :clove

end
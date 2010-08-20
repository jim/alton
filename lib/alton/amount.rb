module Alton

  class Amount < Struct.new(:quantity, :unit)

    def +(other)
      if self.unit == other.unit
        sum = quantity + other.quantity
      else
        sum = self.in(other.unit).quantity + other.quantity
      end
      self.class.new(sum, other.unit)
    end

    def in(new_unit)
      new_unit = Alton::Unit(new_unit.to_s.singularize.to_sym) if new_unit.is_a?(Symbol) || new_unit.is_a?(String)
      raise "in requires either a symbol or Alton::Unit instance" unless new_unit.is_a?(Alton::Unit)
      conversion_rate = self.unit.fl_oz.to_f / new_unit.fl_oz
      sum = quantity * conversion_rate
      sum = sum.to_i if Integer(sum) == sum
      self.class.new(sum, new_unit)
    end
    
    def to_s
      "#{@quantity} #{@unit}"
    end

    def self.parse_quantity(text)
      if text =~ /(.+)\/(.+)/
        numerator, denominator = $1, $2
        if numerator =~ /(.+) +(.+)/
          whole, numerator = $1.to_i, $2
          whole + Rational(numerator.to_i, denominator.to_i)
        else
          Rational(numerator.to_i, denominator.to_i)
        end        
      elsif text =~ /\./
        text.to_f
      else
        text.to_i
      end
    end
    
  end
end
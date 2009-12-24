module Alton

  class Amount < Struct.new(:quantity, :unit)

    def to_s
      "#{@quantity} #{@unit}"
    end

    def self.parse_quantity(text)
      if text =~ /(.+)\/(.+)/
        numerator, denominator = $1, $2
        if numerator =~ /(.+) +(.+)/
          whole, numerator = $1.to_i, $2
          whole + Rational(numerator, denominator)
        else
          Rational(numerator, denominator)
        end        
      elsif text =~ /\./
        # text.to_f
      else
        # text.to_i
      end
    end
    
  end
end
module Alton
  class Amount < Struct.new(:quantity, :unit)
    def to_s
      "#{@quantity} #{@unit}"
    end
  end
end
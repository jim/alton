class Rational
  
  def to_human
    if numerator > denominator
      "#{numerator/denominator} #{numerator%denominator}/#{denominator}"
    else
      to_s
    end
  end
  
end
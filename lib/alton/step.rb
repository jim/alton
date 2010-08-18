module Alton
  class Step < String
    
    def self.parse_block(text)
      text.split("\n").map do |line|
        cleaned = line.gsub(/^\d*\.? ?/, '').strip
        cleaned == '' ? nil : cleaned
      end.collect.map do |step|
        self.new(step)        
      end
    end
    
  end
end
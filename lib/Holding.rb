class Holding

    attr_accessor :symbol
    attr_accessor :shares
    
    def initialize(symbol, shares)
        @symbol = symbol
        @shares = shares
    end
    
end
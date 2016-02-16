class Account

    attr_accessor :holdings
    attr_accessor :number
    
    def initialize(number)
        @holdings = Array.new
    end
    
end
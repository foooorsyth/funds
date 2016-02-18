class Account

    attr_accessor :holdings
    attr_accessor :accountNumber
    attr_accessor :type
    attr_accessor :routingNumber
    
    def initialize(accountNumber, type)
        @accountNumber = accountNumber
        @type = type
        @holdings = Array.new
        @routing = -1
    end
    
end
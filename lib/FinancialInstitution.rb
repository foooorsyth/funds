class FinancialInstitution
    attr_accessor :fid
    attr_accessor :name
    attr_accessor :org
    attr_accessor :url
    
    def initialize(fid, name, org, url)
        @fid = fid;
        @name = name;
        @org = org;
        @url = url;
    end
end

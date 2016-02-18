Gem::Specification.new do |s|
  s.name        = 'funds'
  s.version     = '0.0.2'
  s.date        = '2016-02-17'
  s.summary     = "Funds (alpha)"
  s.description = "An Open Financial Exchange client."
  s.authors     = ["Justin Forsyth"]
  s.email       = 'justin@forsyth.im'
  s.files       = ["lib/Account.rb", 
                   "lib/AccountType.rb", 
                   "lib/FinancialInstitution.rb",
                   "lib/Global.rb",
                   "lib/Holding.rb",
                   "lib/OFXClient.rb",
                   "lib/Statement.rb"]
  s.add_runtime_dependency "nokogiri",
    ["= 1.6.7.2"]
  s.add_runtime_dependency "httpclient",
    ["= 2.7.1"]
  s.homepage    =
    'https://github.com/jf-rce/funds'
  s.license       = 'MIT'
end
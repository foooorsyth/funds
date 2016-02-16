Gem::Specification.new do |s|
  s.name        = 'funds'
  s.version     = '0.0.1'
  s.date        = '2016-02-13'
  s.summary     = "Funds (alpha)"
  s.description = "An Open Financial Exchange client."
  s.authors     = ["Justin Forsyth"]
  s.email       = 'justin@forsyth.im'
  s.files       = ["lib/OFXClient.rb", 
                   "lib/Holding.rb", 
                   "lib/FinancialInstitution.rb",
                   "lib/Account.rb"]
  s.add_runtime_dependency "nokogiri",
    ["= 1.6.7.2"]
  s.add_runtime_dependency "httpclient",
    ["= 2.7.1"]
  s.homepage    =
    'http://rubygems.org/gems/funds'
  s.license       = 'MIT'
end
# funds (alpha)

An Open Financial Exchange client in Ruby

# Installation

`gem install nokogiri -v 1.6.7.2`

`gem install httpclient -v 2.7.1`

`gem install funds`

RubyGem: [https://rubygems.org/gems/funds](https://rubygems.org/gems/funds)

# Usage

### Query ofxhome.com API for FIDs

```Ruby
OFXClient::search_institutions("Fidelity")
```
=> {"Fidelity Investments"=>449, "Fidelity NetBenefits"=>558}

### Retrieve FinancialInstitution by FID

````Ruby
fi = OFXClient::get_institution(449)
unless fi.nil?
  puts fi.fid
  puts fi.name
  puts fi.org
  puts fi.url
end
```
=> 449

=> Fidelity Investments

=> fidelity.com

=> https://ofx.fidelity.com/ftgw/OFX/clients/download

### Retrieve all FIDs

```Ruby
OFXClient::all_institutions
```
=> {"121 Financial Credit Union"=>666, "1st Advantage FCU"=>542, "5 Star Bank"=>774, ... , "Zions Bank"=>630, "zWachovia"=>452}

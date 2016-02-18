# funds (alpha)

An Open Financial Exchange (OFX) client in Ruby

# Installation

`gem install nokogiri -v 1.6.7.2`  
`gem install httpclient -v 2.7.1`  
`gem install funds`

RubyGem: [https://rubygems.org/gems/funds](https://rubygems.org/gems/funds)

# Usage

### Query ofxhome.com API for ofxhome.com institution IDs

```Ruby
OFXClient::search_institutions("Fidelity")
```
=> {"Fidelity Investments"=>449, "Fidelity NetBenefits"=>558}

NOTE: ofxhome.com institution IDs are unique to the ofxhome.com database. These IDs are independent of the OFX FID tied to a given institution. You will use ofxhome.com institution IDs to retrieve an institution's FID.

### Retrieve FinancialInstitution by institution ID

````Ruby
fi = OFXClient::get_institution(449)
unless fi.nil?
  puts fi.fid
  puts fi.name
  puts fi.org
  puts fi.url
end
```
=> 7776  
=> Fidelity Investments  
=> fidelity.com  
=> https://ofx.fidelity.com/ftgw/OFX/clients/download

### Retrieve all FIDs

```Ruby
OFXClient::all_institutions
```
=> {"121 Financial Credit Union"=>666, "1st Advantage FCU"=>542, ... , "Zions Bank"=>630, "zWachovia"=>452}

### Get a credit card statement

```Ruby
# Retrieve a FinancialInstitution
fi = OFXClient::get_institution(449)
# Create an Account by with your account number and an AccountType (CHECKING, SAVINGS, MONEYMRKT, CREDITCARD)
account = Account.new("1234567890123456", AccountType::CREDITCARD)
# fetch the OFX statement(s) in date range (yyyymmdd) from the institution
# currently, this call returns the raw OFX body response
puts OFXClient::get_statement(fi, account, "myOnlineUsername", "myPassword", "20151201", "20160115")
```
Response:
```
OFXHEADER:100
DATA:OFXSGML
VERSION:102
SECURITY:NONE
ENCODING:USASCII
CHARSET:1252
COMPRESSION:NONE
OLDFILEUID:NONE
NEWFILEUID:NONE

<OFX>
<SIGNONMSGSRSV1>
<SONRS>
<STATUS>
<CODE>0
<SEVERITY>INFO
</STATUS>...
```
### Get a checking statement
```Ruby
# Retrieve a FinancialInstitution
fi = OFXClient::get_institution(449)
# Create an Account by with your account number and an AccountType (CHECKING, SAVINGS, MONEYMRKT, CREDITCARD)
account = Account.new("1234567890123456", AccountType::CREDITCARD)
# CHECKING/SAVINGS accounts require a routing number
account.routingNumber = "0010020032"
# fetch the OFX statement(s) in date range (yyyymmdd) from the institution
# currently, this call returns the raw OFX body response
puts OFXClient::get_statement(fi, account, "myOnlineUsername", "myPassword", "20151201", "20160115")
```

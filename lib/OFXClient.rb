require "./FinancialInstitution.rb"
require "./Account.rb"
require "./AccountType.rb"
require "./Global.rb"
require "rubygems"
require "httpclient"
require "nokogiri"

class OFXClient
    
    def self.get_statement(fi, account, username, password, startDate, endDate)
        
        if(account.type.eql?(AccountType::CHECKING) || account.type.eql?(AccountType::SAVINGS))
            ofx = OFXClient::create_headers() + 
            '<OFX>' +
            create_signon(fi, username, password) +
            '<BANKMSGSRQV1>' +
            '<STMTTRNRQ>' +
            '<TRNUID>' + OFXClient::generate_uuid(32) +
            '<CLTCOOKIE>' + OFXClient::generate_uuid(5) +
            '<STMTRQ>' +
            '<BANKACCTFROM>' +
            '<BANKID>' + account.routingNumber +
            '<ACCTID>' + account.accountNumber +
            '<ACCTTYPE>' + account.type +
            '</BANKACCTFROM>' +
            '<INCTRAN>' +
            '<DTSTART>' + startDate +
            '<DTEND>' + endDate +
            '<INCLUDE>Y</INCTRAN>' +
            '</STMTRQ>' +
            '</STMTTRNRQ>' +
            '</BANKMSGSRQV1>' +
            '</OFX>';
            
            OFXClient::post_ofx(fi.url, ofx);
        end
        
        if(account.type.eql?(AccountType::CREDITCARD))
        
            ofx = OFXClient::create_headers() + 
            '<OFX>' +
            create_signon(fi, username, password) +
            '<CREDITCARDMSGSRQV1>' +
            '<CCSTMTTRNRQ>' +
            '<TRNUID>' + OFXClient::generate_uuid(32) +
            '<CLTCOOKIE>' + OFXClient::generate_uuid(5) +
            '<CCSTMTRQ>' +
            '<CCACCTFROM>' +
            '<ACCTID>' + account.accountNumber  +
            '</CCACCTFROM>' +
            '<INCTRAN>' +
            '<DTSTART>' + startDate +
            '<INCLUDE>Y</INCTRAN>' +
            '</CCSTMTRQ>' +
            '</CCSTMTTRNRQ>' +
            '</CREDITCARDMSGSRQV1>' +
            '</OFX>';
            
            OFXClient::post_ofx(fi.url, ofx);
        
        end
    
    end
    
    # returns hash of FI names : fids 
    # names include or match the passed search term
    def self.search_institutions(term)
        httpClient = HTTPClient.new
        res = httpClient.get_content("http://www.ofxhome.com/api.php?search=" + term)
        doc = Nokogiri::XML(res)
        return OFXClient::doc_to_hash(doc)
    end
    
    # returns hash of ALL FI names : fids 
    def self.all_institutions
        httpClient = HTTPClient.new
        res = httpClient.get_content("http://www.ofxhome.com/api.php?all=yes")
        doc = Nokogiri::XML(res)
        return OFXClient::doc_to_hash(doc)
    end
    
    def self.get_institution(iid)
        httpClient = HTTPClient.new
        res = httpClient.get_content("http://www.ofxhome.com/api.php?lookup=" + iid.to_s)
        doc = Nokogiri::XML(res)
        
        institutionElements = doc.xpath("//institution")
        
        if(institutionElements.length == 1)
           if(institutionElements.first["id"].eql? iid.to_s)
                fid = doc.xpath("//institution//fid").first.content.to_i
                name = doc.xpath("//institution//name").first.content
                org = doc.xpath("//institution//org").first.content
                url = doc.xpath("//institution//url").first.content
                
                return FinancialInstitution.new(fid, name, org, url)
                
            else
                # error in ofxhome api
                return nil
            end
        else
            # the institution with specified fid doesn't exist
            # in the ofxhome.com database
            return nil
        end
    end
    
    def self.post_ofx(url, ofxBody)
    
        httpClient = HTTPClient.new
        #required headers
        extheader = [['Content-Type', 'application/x-ofx']]
        extheader = [['User-Agent', 'funds']]
        #extheader.push(['Content-Length', ofxBody.bytesize.to_s])
        extheader.push(['Accept', 'application/ofx'])
        
        res = httpClient.post(url, ofxBody, extheader, nil)

        return res.body
        
    end

    private
    
    def self.generate_uuid(length)
    
        chars = ("0".."9").to_a.concat(("A".."Z").to_a.concat(("a".."z").to_a))
        radix = chars.length      
        uuid = Array.new
        
        (0...length).each do |i|
            uuid.push(chars[rand(chars.length)])
        end
        
        return uuid.join
        
    end
    
    def self.doc_to_hash(doc)
        hash = Hash.new
        doc.xpath("//institutionid").each do |node|
            hash[node["name"]] = node["id"].to_i
        end
        return hash
    end
    
    def self.create_headers
         
         return 'OFXHEADER:100\r\n' +
         'DATA:OFXSGML\r\n' +
         'VERSION:'+ '102' +'\r\n' +
         'SECURITY:NONE\r\n' +
         'ENCODING:USASCII\r\n' +
         'CHARSET:1252\r\n' +
         'COMPRESSION:NONE\r\n' +
         'OLDFILEUID:NONE\r\n' +
         'NEWFILEUID:' + OFXClient::generate_uuid(32) + '\r\n' +
         '\r\n'
    end
    
    def self.create_signon(fi, username, password)
    
        return '<SIGNONMSGSRQV1>' +
        '<SONRQ>' +
        '<DTCLIENT>' + Time.new.strftime("%Y%m%d%H%M%S") +
        '<USERID>' + username +
        '<USERPASS>' + password +
        '<LANGUAGE>ENG' +
        '<FI>' +
        '<ORG>' + fi.org +
        '<FID>' + fi.fid.to_s +
        '</FI>' +
        '<APPID>' + "funds" +
        '<APPVER>' + Global::VERSION +
        '</SONRQ>' +
        '</SIGNONMSGSRQV1>'
      
    end

end

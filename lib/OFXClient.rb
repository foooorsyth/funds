require "./FinancialInstitution.rb"
require "rubygems"
require "httpclient"
require "nokogiri"

class OFXClient

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
    
    def self.get_institution(fid)
        httpClient = HTTPClient.new
        res = httpClient.get_content("http://www.ofxhome.com/api.php?lookup=" + fid.to_s)
        doc = Nokogiri::XML(res)
        
        institutionElements = doc.xpath("//institution")
        
        if(institutionElements.length == 1)
           if(institutionElements.first["id"].eql? fid.to_s)
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
    
    private
    
    def self.doc_to_hash(doc)
        hash = Hash.new
        doc.xpath("//institutionid").each do |node|
            hash[node["name"]] = node["id"].to_i
        end
        return hash
    end


end

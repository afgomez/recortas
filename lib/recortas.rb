require 'net/http'
require 'rexml/document'

class URIError < ArgumentError; end

class Recortas
  
  def self.decode(uri)
    raise URIError, "Not a valid cort.as URI" unless uri =~ /^http:\/\/cort\.as/
    
    xml_data = Net::HTTP.get_response(URI.parse("#{uri}.xml")).body
    xml_doc = REXML::Document.new(xml_data)

    if xml_doc.root.children[0].text == 'ok'
      xml_doc.root.children[1].text
    else
      raise URIError, REXML::XPath.first(xml_doc, '//errorLong').text
    end
  end
end

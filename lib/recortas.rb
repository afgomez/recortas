require 'net/http'
require 'rexml/document'

class Recortas
  
  def self.decode(url)
    
    xml_data = Net::HTTP.get_response(URI.parse("#{url}.xml")).body
    xml_doc = REXML::Document.new(xml_data)
    
    if xml_doc.root.children[0].text == 'ok'
      xml_doc.root.children[1].text
    else
      raise ArgumentError, REXML::XPath.first(xml_doc, '//errorLong').text
    end
    
    
  end
end

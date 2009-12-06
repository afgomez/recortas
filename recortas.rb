# re.cort.as A ruby wrapper for the cort.as service
#
# Copyright (c) 2009, Alejandro Fernández Gómez
# All rights reserved.
# 
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#     * Redistributions of source code must retain the above copyright
#       notice, this list of conditions and the following disclaimer.
#     * Redistributions in binary form must reproduce the above copyright
#       notice, this list of conditions and the following disclaimer in the
#       documentation and/or other materials provided with the distribution.
#     * Neither the name of the <organization> nor the
#       names of its contributors may be used to endorse or promote products
#       derived from this software without specific prior written permission.
# 
# THIS SOFTWARE IS PROVIDED BY Alejandro Fernández Gómez ''AS IS'' AND ANY
# EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL Alejandro Fernández Gómez BE LIABLE FOR ANY
# DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
# (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
# LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
# ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
# SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

require 'net/http'
require 'rexml/document'

class URIError < ArgumentError; end



class Recortas
  
  def self.decode(uri)
    raise URIError, "Not a valid cort.as URI" unless uri =~ /^http:\/\/cort\.as/i
    
    xml_data = Net::HTTP.get_response(URI.parse("#{uri}.xml")).body
    xml_doc = REXML::Document.new(xml_data)

    if xml_doc.root.children[0].text == 'ok'
      xml_doc.root.children[1].text
    else
      raise URIError, REXML::XPath.first(xml_doc, '//errorLong').text
    end
  end
  
  def self.encode(uri)
    
    xml_data = Net::HTTP.get_response(URI.parse("http://www.soitu.es/cortas/encode.pl?r=xml&u=#{uri}")).body
    xml_doc = REXML::Document.new(xml_data)
    
    if xml_doc.root.children[0].text == 'ok'
      REXML::XPath.first(xml_doc, '//urlCortas').text
    else
      raise URIError, REXML::XPath.first(xml_doc, '//errorLong').text
    end
  end
end

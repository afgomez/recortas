# = re.cort.as A ruby wrapper for the http://cort.as service
#
# re.cort.as is a basic ruby wrapper for the http://soitu.es http://cort.as service.
#
# Currently only have two methods: one for decoding and one for encoding an URI.
# Support for statistics is planned
#
# == Encoding an URI
# 
#     Recortas::encode(uri)
# 
# Returns a string with the shortened URI
# 
# == Decoding an cort.as URI
#     
#     Recortas::decode(uri)
# 
# Returns a string with the original URI. The uri parameter must be a valid cort.as uri (i.e. must start with 'http://cort.as')
# 
# If an error occurs, an exception of class CortasError is raised.
# 
#     begin
#       Recortas::decode('http://www.google.com')
#     rescue CortasError => e
#       puts e # Not a valid cort.as URI
#     end
# 
# Author:: Alejandro Fernández Gómez,  antarticonorte@gmail.com
# Version::  0.1
# License::  BSD
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
# * Redistributions of source code must retain the above copyright
#   notice, this list of conditions and the following disclaimer.
# * Redistributions in binary form must reproduce the above copyright
#   notice, this list of conditions and the following disclaimer in the
#   documentation and/or other materials provided with the distribution.
# * Neither the name of the <organization> nor the
#   names of its contributors may be used to endorse or promote products
#   derived from this software without specific prior written permission.
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

# = CortasError
# Exception raised when:
# * A URI cannot be encoded with Recortas.encode
# * An invalid URI is passed to Recortas.decode
class CortasError < ArgumentError; end


class Recortas
  
  # Get the original URI shortened with cort.as as a string
  #
  # Usage example
  #   original = Recortas::decode('http://cort.as/1')   # Returns 'http://www.yahoo.com/'
  # 
  # Raises CortasError when +uri+ is not a cort.as URI
  
  def self.decode(uri)
    
    raise CortasError, "Not a valid cort.as URI" unless uri =~ /^http:\/\/cort\.as/i
    
    xml_data = Net::HTTP.get_response(URI.parse("#{uri}.xml")).body
    xml_doc = REXML::Document.new(xml_data)

    if xml_doc.root.children[0].text == 'ok'
      xml_doc.root.children[1].text
    else
      raise URIError, REXML::XPath.first(xml_doc, '//errorLong').text
    end
  end
  
  # Sends an URI to http://cort.as to be shortened
  #
  # Usage example
  #   short = Recortas::encode('http://www.yahoo.com')  # Returns 'http://cort.as/1'
  #
  # Raises CortasError if the +uri+ cannot be shortened
  #
  #   begin
  #     short = Recortas::encode('blalal')
  #   rescue CortasError => e
  #     puts e  # Error returned from cort.as service
  #   end

  def self.encode(uri)
    
    xml_data = Net::HTTP.get_response(URI.parse("http://www.soitu.es/cortas/encode.pl?r=xml&u=#{uri}")).body
    xml_doc = REXML::Document.new(xml_data)
    
    if xml_doc.root.children[0].text == 'ok'
      REXML::XPath.first(xml_doc, '//urlCortas').text
    else
      raise CortasError, REXML::XPath.first(xml_doc, '//errorLong').text
    end
  end
end

require 'lib/recortas'

# Decoding an URI
puts Recortas::decode('http://cort.as/1')

# Invalid short code
begin
  puts Recortas::decode('http://cort.as/111111111111111')
rescue URIError => e
  puts "Err: #{e}"
end

# Invalid cort.as URI
begin
  puts Recortas::decode('http://google.com')
rescue URIError => e
  puts "Err: #{e}"
end
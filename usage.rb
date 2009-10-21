require 'lib/recortas'

# Decoding an URL
puts Recortas::decode('http://cort.as/1')

begin
  puts Recortas::decode('http://cort.as/111111111111111')
rescue ArgumentError => e
  puts "server said: #{e}"
end
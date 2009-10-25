require 'lib/recortas'

# Decoding an URI
puts Recortas::decode('http://cort.as/1')

# Encoding an URI
puts Recortas::encode('http://www.yahoo.com/')
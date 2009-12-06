# re.cort.as A ruby wrapper for the [cort.as](http://cort.as) service

re.cort.as is a basic ruby wrapper for the [soitu.es](http://soitu.es/) [cort.as](http://cort.as/) service. Currently only have two methods: one for decoding and one for encoding an URI

## Usage

**Encoding an URI**

    Recortas::encode(uri)

Returns a string with the shortened URI

**Decoding an existing URI**
    
    Recortas::decode(uri)

Returns a string with the original URI. The uri parameter must be a valid cort.as uri (i.e. must start with 'http://cort.as')

If an error occurs, an exception of class URIError is raised.

    begin
      Recortas::decode('http://www.google.com')
    rescue URIError => e
      puts e # Not a valid cort.as URI
    end

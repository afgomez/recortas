# recortas A ruby wrapper for the [cort.as](http://cort.as) service

recortas is a basic ruby wrapper for the [soitu.es](http://soitu.es/) [cort.as](http://cort.as/) service.

Currently only have two methods: one for decoding and one for encoding an URI. Support for statistics is planned

## Usage

To use recortas you only have to require it in your script

    require 'rubygems'
    require 'recortas'

**Encoding an URI**

    Recortas.encode(uri)

Returns a string with the shortened URI. Raises CortasError if the +uri+ cannot be shortened

    begin
      short = Recortas.encode('blalal')
    rescue CortasError => e
      puts e  # Error returned from cort.as service
    end

**Decoding an existing URI**
    
    Recortas.decode(uri)

Returns a string with the original URI. The uri parameter must be a valid cort.as uri (i.e. must start with 'http://cort.as')

If an error occurs, an exception of class CortasError is raised.

    begin
      Recortas.decode('http://www.google.com')
    rescue CortasError => e
      puts e # Not a valid cort.as URI
    end


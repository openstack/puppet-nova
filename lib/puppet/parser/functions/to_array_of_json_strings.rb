require 'json'

def array_of_hash?(list)
  return false unless list.class == Array
  list.each do |e|
    return false unless e.class == Hash
  end
  true
end

module Puppet::Parser::Functions
  newfunction(:to_array_of_json_strings, :arity =>1, :type => :rvalue, :doc => "Convert
    input array of hashes (optionally JSON encoded) to a puppet Array of JSON encoded Strings") do |arg|
    list = arg[0]
    if list.class == String
      begin
        begin
          list = JSON.load(list)
        rescue JSON::ParserError
          # If parsing failed it could be a legacy format that uses single quotes.
          # NB This will corrupt valid JSON data, e.g {"foo": "\'"} => {"foo": "\""}
          list = JSON.load(list.gsub("'","\""))
          Puppet.warning("#{arg[0]} is not valid JSON. Support for this format is deprecated and may be removed in future.")
        end
      rescue JSON::ParserError
        raise Puppet::ParseError, "Syntax error: #{arg[0]} is not valid"
      end
    end
    unless array_of_hash?(list)
      raise Puppet::ParseError, "Syntax error: #{arg[0]} is not an Array or JSON encoded String"
    end
    rv = []
    list.each do |e|
      rv.push(e.to_json)
    end
    return rv
  end
end

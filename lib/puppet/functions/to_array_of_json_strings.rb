# Convert input array of hashes (optionally JSON encoded)
# to a puppet Array of JSON encoded Strings.
Puppet::Functions.create_function(:to_array_of_json_strings) do
  def _array_of_hash?(list)
    return false unless list.class == Array
    list.each do |e|
      return false unless e.class == Hash
    end
    true
  end

  def to_array_of_json_strings(*args)
    require 'json'

    if (args.size != 1) then
      raise Puppet::ParseError, 'to_array_of_json_strings(): Wrong number of arguments'
    end
    list = args[0]
    if list.class == String
      begin
        begin
          list = JSON.load(list)
        rescue JSON::ParserError
          # If parsing failed it could be a legacy format that uses single quotes.
          # NB This will corrupt valid JSON data, e.g {"foo": "\'"} => {"foo": "\""}
          list = JSON.load(list.gsub("'","\""))
          Puppet.warning("#{args[0]} is not valid JSON. Support for this format is deprecated and may be removed in future.")
        end
      rescue JSON::ParserError
        raise Puppet::ParseError, "Syntax error: #{args[0]} is not valid"
      end
      list = [list] unless list.class == Array
    end
    unless _array_of_hash?(list)
      raise Puppet::ParseError, "Syntax error: #{args[0]} is not an Array or JSON encoded String"
    end
    rv = []
    list.each do |e|
      rv.push(e.to_json)
    end
    return rv
  end
end

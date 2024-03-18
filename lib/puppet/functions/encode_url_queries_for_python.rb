Puppet::Functions.create_function(:encode_url_queries_for_python) do

  def encode_url_queries_for_python(*args)
    require 'uri'

    if (args.size != 1) then
      raise Puppet::ParseError, 'encode_url_queries_for_python(): Wrong number of arguments'
    end
    queries = args[0]
    if queries.class != Hash
      raise Puppet::ParseError, "encode_url_queries_for_python(): Requires a Hash, got #{queries.class}"
    end

    if queries.empty?
      return ''
    end
    return '?' + URI.encode_www_form(queries).gsub(/%/, '%%')
  end
end

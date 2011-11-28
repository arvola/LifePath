require 'cgi'

module Rapid

    # GET and POST input parser
    # Lazy processing
    class Input
        attr_reader :query_raw, :post_raw
        
        def initialize query_string, post_body = nil
            @query_raw = query_string
            @post_raw = post_body
            debuglog "Get raw: " << @query_raw
            debuglog "Post raw: " << @post_raw
        end

        def get key
            if !defined? @query
                @query = Input.parse @query_raw
                debuglog "Query string parsed: " << @query.to_s
            end

            return @query[key] if @query.has_key?(key)
            nil
        end
        def post key
            return nil if @post_raw.nil?

            if !defined? @post
                @post = Input.parse @post_raw
                debuglog "POST string parsed: " << @post.to_s
            end

            return @post[key] if @post.has_key?(key)
            nil
        end

        def Input.parse string
            arr = {}
            string.split(/&|;/).each do |v|
                key, value = Input.parse_pair v
                arr[key.downcase.to_sym] = CGI::unescape(value)
            end
            arr
        end
        def Input.parse_pair string
            string.split('=')
        end
    end
end
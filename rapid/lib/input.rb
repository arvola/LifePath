# LifePath
#
# Author:: Mikael Arvola
# License:: MIT

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

        def get key = nil
            unless defined? @query
                @query = Input.parse @query_raw
                debuglog "Query string parsed: " << @query.to_s
            end

            if key.nil?
                @query
            elsif @query.has_key? key
                @query[key]
            else
                nil
            end
        end
        def post key = nil
            return nil if @post_raw.nil?

            unless defined? @post
                @post = Input.parse @post_raw
                debuglog "POST string parsed: " << @post.to_s
            end

            if key.nil?
                @post
            elsif @post.has_key? key
                @post[key]
            else
                nil
            end
        end

        def Input.parse string
            arr = {}
            string.split(/&|;/).each do |v|
                debuglog "Parsing " + v.to_s
                key, value = Input.parse_pair v
                arr[key.downcase.to_sym] = CGI::unescape(value) if value
            end
            arr
        end
        def Input.parse_pair string
            string.split('=')
        end
    end
end
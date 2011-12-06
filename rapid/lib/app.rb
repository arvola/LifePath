# LifePath
#
# Author:: Mikael Arvola
# License:: MIT

require 'event'
require 'pages'
require 'exception'
require 'input'

module Rapid
    # Base class for HTTP applications
    class App
        attr_accessor :status, :content_type, :content, :events

        def initialize env
            # Defaults
            @status = 404
            @content_type = 'text/plain'
            @content = ''

            @env = env
            @arg = env['PATH_INFO'].downcase.sub(/^\//, '').split(/\//)
            @db = env['db']

            env['rack.input'].rewind
            post = env['rack.input'].read
            @in = Input.new env['QUERY_STRING'], post

            # A new event manager
            @e = Rapid::Event.new

            # Create events that apply to all apps
            # error: Fired after an error of some sort
            # before: Fired right before the app is run
            # after: Fired after the app has been run
            # pre_response: Fired right before the response is sent back to the browser
            @e << :error << :after << :before << :pre_response
            
            @e.error &self.method(:error)

            debuglog "App initialized: " + self.class.to_s
        end

        def post?
            @env['REQUEST_METHOD'].casecmp("post") == 0
        end

        def get?
            @env['REQUEST_METHOD'].casecmp("get") == 0
        end

        # Set HTTP status to not found
        def status_not_found
            @status = 404
            @e.error 'The requested page does not exist.', 404
            throw :exit
        end

        # Set HTTP status to forbidden
        def status_forbidden
            @status = 403
        end

        # Set HTTP status to internal server error
        def status_error
            @status = 500
        end

        # Build the response from the initialized application
        def get_response
            debuglog 'get_response'
            response = rack_response
            @e.pre_response response
            response
        end

        def rack_response
            [@status, {"Content-type" => @content_type}, [@content]]
        end

        # The first error handler in the event chain
        def error(event, msg, code=500, trace = [])
            title = case code
                        when 400
                            "Bad Request (400)"
                        when 401
                            "Unauthorized Request"
                        when 403
                            "Access Restricted"
                        when 404
                            "Page Not Found"
                        when 405
                            "HTTP Method Not Allowed"
                        else
                            "An Error Has Occured"
                    end
            @content = render('error.haml', {title: title, message: msg, error_code: code, trace: trace})
            warnlog 'Error handler called with "' << msg << '", code ' << code.to_s << ' (trace: ' << trace.to_s << ')'
        end
    end
end
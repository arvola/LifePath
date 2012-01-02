# LifePath
#
# Author:: Mikael Arvola
# License:: MIT

$:.unshift(File.expand_path(File.dirname(__FILE__)))
$:.unshift(File.expand_path(File.dirname(__FILE__)) + "/lib")
$:.unshift(File.expand_path(File.dirname(__FILE__)) + "/lib/slim/lib")
$:.unshift(File.expand_path(File.dirname(__FILE__)) + "/lib/temple/lib")
$BASE_PATH = File.expand_path(File.dirname(__FILE__) + "/../")
$APPS_PATH = $BASE_PATH + "/apps"

require 'log'
require 'buffer'
require 'router'
require 'htmlentities'
require 'config'

# Profiling purposes
#require 'ruby-prof'
#require 'uri'

# Main RapidRuby module
module Rapid
    # Bootstrap for RapidRuby apps
    class RapidBooter
        def initialize
            debuglog "-----------------RAPIDRUBY PROCESS STARTED-----------------"
            Dir.glob ($BASE_PATH + "/rapid/lib/app/*.rb") do |file|
                debuglog "Found app file: " + file
                require file
            end

            App.subclasses().each do |klass|
                router = klass.method(:router).call
                Rapid.add_route router
            end
        end

        # Bootstrap a response to a request
        def boot(env)
            #RubyProf.start
            debuglog "Entering boot for " + env['PATH_INFO']

            # The router determines the app, and then instance it
            app = Rapid.route(env['PATH_INFO']).new(env)

            # Buffer output so we don't send anything unintentionally
            error_content = nil
            text = Rapid.buffer do
                catch (:exit) do
                    begin
                        app.run
                    rescue Exception
                        coder = HTMLEntities.new
                        error_content = "<h2>" << $!.class.to_s << ": " << coder.encode($!.message, :named) << "</h2>"
                        trace = $!.backtrace.map { |v| "<div>#{v}</div>" }.join("\n")
                        error_content << "<p>" << trace << "</p>"
                    end
                end
            end

            debuglog "Buffer shield: " + text if text
            debuglog "-----------------RAPIDRUBY PROCESS SHUTDOWN-----------------"

            #profiling = RubyProf.stop
            #printer = RubyProf::GraphHtmlPrinter.new(profiling)
            #File.open($BASE_PATH + '/prof/run/' + URI.escape(env['PATH_INFO']).gsub('/', '-') + '.html', 'w') {|f| printer.print(f, {}) }

            unless error_content.nil?
                return [500, {"Content-Type" => "text/html"}, [error_content]]
            end

            if true
                app.get_response
            else
                [500, {"Content-Type" => "text/html"}, [File.open('fallback.html') { |f| f.read }]]
            end
        end
    end
end
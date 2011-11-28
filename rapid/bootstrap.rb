$:.unshift(File.expand_path(File.dirname(__FILE__)))
$:.unshift(File.expand_path(File.dirname(__FILE__)) + "/lib")
$BASE_PATH = File.expand_path(File.dirname(__FILE__) + "/../")
$APPS_PATH = $BASE_PATH + "/apps"

require 'log'
require 'buffer'
require 'router'
require 'htmlentities'
require 'config'

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
      debuglog "Entering boot for " + env['PATH_INFO']

      # The router determines the app, and then instance it
      app  = Rapid.route(env['PATH_INFO']).new(env)

      # Buffer output so we don't send anything unintentionally
      error_content = nil
      text = Rapid.buffer do
        catch (:exit) do
          begin
            app.run
          rescue Exception
            coder         = HTMLEntities.new
            error_content = "<h2>" << $!.class.to_s << ": " << coder.encode($!.message, :named) << "</h2>"
            trace         = $!.backtrace.map { |v| "<div>#{v}</div>" }.join("\n")
            error_content << "<p>" << trace << "</p>"
          end
        end
      end

      debuglog "Buffer shield: " + text
      debuglog "-----------------RAPIDRUBY PROCESS SHUTDOWN-----------------"
      if !error_content.nil?
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
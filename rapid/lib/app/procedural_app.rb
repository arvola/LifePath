# LifePath
#
# Author:: Mikael Arvola
# License:: MIT

require 'app'
require 'exception'
require 'rack'
require 'ap'
require 'router'
require 'app_utility'

module Rapid
  # A normal web page script, procedural style
  class ProceduralApp < App
    include Pages
    include AppUtility
    class << self
      attr_accessor :controller_path, :file_cache
    end
    @controller_path = $APPS_PATH + "/procedural/controllers/"
    @file_cache = {}

    def self.router
      router        = Router.new(ProceduralApp) { true }
      router.weight = 100
      router
    end

    def initialize env
      super env

      @content_type = 'text/html'
    end

    def pap var
      puts '<pre>'
      ap var
      puts '</pre>'
    end

    # Runs the controller
    def run
      debuglog '--------- Running app ' << self.class.to_s
      # Fire the before event
      @e.before self
      # First argument is the controller
      @controller = @arg.first

      # If the first argument was null, use the default controller
      @controller = 'index' unless @controller

      # Build the path to the controller file
      @control_file = self.class.controller_path + @controller + ".rb"

      # When something, such as an error, happens and we don't want to
      # finish

      begin
        File.open(@control_file, 'r') do |file|
          self.class.file_cache[@controller] = file.read
        end unless self.class.file_cache.key? @controller

        controller = self.class.file_cache[@controller]

        # Assume a success status
        @status    = 200
        # Buffer the output
        content    = Rapid.buffer do
          # The controller is evaluated within the ControllerApp instance's context
          begin
            instance_eval(controller)
          rescue Exception
            debuglog "Rescuing controller exception."
            # Wrap the exception in the controller and pass it along
            raise ControllerException.new("Controller exception", $!, @controller), "test"
          end
        end
        @content   = content
      rescue Errno::ENOENT
        debuglog 'Controller file not found for ' << @controller
        status_not_found
          # The exception happened when evaluating the controller file
      rescue ControllerException
        debuglog 'ControllerException caught'
        @status = 500
        @e.error $!.message, 500, $!.backtrace
        throw :exit
      end

      # Finished, fire the after event
      @e.after self

      self
    end
  end
end
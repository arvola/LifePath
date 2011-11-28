require 'app'
require 'exception'
require 'rack'
require 'pp'
require 'router'
require 'facets/array'

module Rapid
  # MVC based app
  class MvcApp < App
    include Pages
    # List of pages (first part of path) to go through MVC
    @@config = IniFile.load($BASE_PATH + '/config/mvc.ini')
    @@mvc = @@config['routes']['path'].split

    def self.router
      router        = Router.new(MvcApp) do |uri|
        arg = /^\/?([a-z0-9]+)\/.*/i.match(uri)

        if arg == nil
          false
        else
          @@mvc.include? arg[1]
        end
      end
      router.weight = 10
      router
    end

    def initialize env
      super env

      @controller_actions = Hash.new
      @controller_cache   = Hash.new
      @content_type       = 'text/html'
      @status             = 200

      # Cache all controllers
      Dir.glob ($BASE_PATH + "/mvc/controllers/*.rb") do |file|
        debuglog "[MVC] Found controller file: " + file
        require file
      end

      Rapid::Controller.subclasses().each do |klass|
        # Read and cache all existing actions
        actions                         = klass.instance_methods.grep(/.*_action$/) { |v| v[0..-8] }
        controller                      = klass.to_s.split('::').last.downcase
        @controller_actions[controller] = actions
        @controller_cache[controller]   = klass
      end
    end

    def run
      controller = @arg.first
      controller = 'index' unless controller
      action = @arg[1]
      action = 'index' unless @action
      debuglog "Running MVC for '" + controller + "' with action: " + action

      if (@controller_actions.include?(controller) && @controller_actions[controller].include?(action))
        run_action @controller_cache[controller], action
      else
        status_not_found
      end
    end

    def run_action control, action
      controller = control.new
      if controller.respond_to? ((action + "_action").to_sym)
        buff = Rapid.buffer do
          controller.send(action + "_action")
        end
        @content = buff
      end
    end
  end
end

require 'app'
require 'exception'
require 'rack'
require 'pp'
require 'router'
require 'facets/array'
require 'mvc/controller'

module Rapid
    # MVC based app
    class MvcApp < App
        include Pages
        class << self
            attr_accessor :controller_path, :controller_actions, :controller_cache
        end
        # List of pages (first part of path) to go through MVC
        @config = IniFile.load($BASE_PATH + '/config/mvc.ini')
        @mvc = @config['routes']['path'].split

        @controller_path = $APPS_PATH + "/mvc/controllers/"
        @controller_actions = Hash.new
        @controller_cache = Hash.new

        # Cache all controllers
        Dir.glob (@controller_path + "*.rb") do |file|
            debuglog "[MVC] Found controller file: " + file
            require file
        end

        Rapid::Controller.subclasses().each do |klass|
            # Read and cache all existing actions
            actions = klass.instance_methods.grep(/.*_action$/) { |v| v[0..-8] }
            controller = klass.to_s.split('::').last.downcase
            @controller_actions[controller] = actions
            @controller_cache[controller] = klass
        end

        def self.router
            router = Router.new(MvcApp) do |uri|
                arg = /^\/?([a-z0-9]+)(\/.*|$)/i.match(uri)

                if arg == nil
                    false
                else
                    @mvc.include? arg[1]
                end
            end
            router.weight = 10
            router
        end

        def initialize env
            super env

            @content_type = 'text/html'
            @status = 200
        end

        def run
            controller = @arg.first
            controller = 'index' unless controller
            action = @arg[1]
            action = 'index' unless action
            debuglog "Running MVC for '" + controller + "' with action: " + action

            if (self.class.controller_actions.include?(controller) && self.class.controller_actions[controller].include?(action))
                out = run_action self.class.controller_cache[controller], action
                warnlog("Controller '#{controller}' with action '#{action}' produced no output.") unless out.length > 0
                @content = out
            else
                status_not_found
            end
        end

        def run_action control, action
            controller = control.new
            # This check in theory is redundant. Will restore if it becomes
            # a problem.
            #if controller.respond_to? ((action + "_action").to_sym)
            buff = Rapid.buffer do
                controller.send(action + "_action")
            end
            buff
            #end
        end
    end
end

# LifePath
#
# Author:: Mikael Arvola
# License:: MIT

require 'app_utility'
require 'session'

module Rapid
    class Controller
        include Pages
        include AppUtility
        include SessionUtils
        attr_accessor :app

        def initialize env, app
            @env = env
            @app = app
        end

        def get key = nil
            @app.in.get key
        end
        def post key = nil
            @app.in.post key
        end
        def input
            @app.in
        end
    end
end
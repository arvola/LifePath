# LifePath
#
# Author:: Mikael Arvola
# License:: MIT


require 'app_utility'

module Rapid
    class Controller
        include Pages
        include AppUtility

        def initialize env
            @env = env
        end

    end
end
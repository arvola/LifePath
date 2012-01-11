# LifePath
#
# Author:: Mikael Arvola
# License:: MIT

require 'mvc/model_loader2'
require 'user'

module Rapid
    module AppUtility
        def m
            @models ||= ModelLoader2.new
        end

        def j
            @javascript ||= {}
        end

    end
end

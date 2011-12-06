require 'mvc/model_loader2'

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
require 'mvc/model_loader2'

module Rapid
    class Controller
        include Pages

        def initialize
            @models = ModelLoader2.new
        end

        def m
            @models
        end
    end
end
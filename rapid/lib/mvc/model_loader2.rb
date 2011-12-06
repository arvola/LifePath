require 'mvc/model'
require 'facets/module'

class String
    def underscore
        self.gsub(/::/, '/').
                gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2').
                gsub(/([a-z\d])([A-Z])/, '\1_\2').
                tr("-", "_").
                downcase
    end
end

module Rapid
    class ModelLoader2
        class << self
            attr_accessor :model_path, :model_cache
        end

        @model_path = $APPS_PATH + "/mvc/models/"
        @model_cache = Hash.new

        # Cache all controllers
        Dir.glob (@model_path + "*.rb") do |file|
            debuglog "[MVC] Found model file: " + file
            require file
        end

        Rapid::Model.subclasses().each do |klass|
            sym = klass.to_s.underscore.to_sym
            @model_cache[sym] = klass
            class_def sym do
                unless @model_instances.has_key?(sym)
                    @model_instances[sym] = self.class.model_cache[sym].new
                end
                @model_instances[sym]
            end
        end

        def initialize
            @model_instances = {}
        end

        def method_missing id, *args
            raise "ModelLoader attempted to load non-existent model"
        end
    end
end
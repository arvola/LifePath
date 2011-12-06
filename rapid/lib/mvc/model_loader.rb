require 'mvc/model'

class String
  def underscore
    self.gsub(/::/, '/').
    gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
    gsub(/([a-z\d])([A-Z])/,'\1_\2').
    tr("-", "_").
    downcase
  end
end

module Rapid
    class ModelLoader
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
            @model_cache[klass.to_s.underscore.to_sym] = klass
        end

        def initialize
            @model_instances = {}
        end

        def method_missing id, *args

            if self.class.model_cache.has_key?(id)
                # Lazy load instances of models
                unless @model_instances.has_key?(id)
                    @model_instances[id] = self.class.model_cache[id].new(*args)
                end
                @model_instances[id]
            else
                raise "ModelLoader attempted to load non-existent model"
            end
        end
    end
end
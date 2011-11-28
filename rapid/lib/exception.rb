module Rapid
    class ControllerException < StandardError
        def initialize msg, err, controller = null
            super(msg)
            @error = err
            @controller = controller
        end

        def to_s
            self.class.to_s << ": " << @error.message
        end

        def to_str
            "Exception in controller '#{@controller}': " << @error.message
        end
        alias :message :to_str

        def backtrace
            @error.backtrace
        end
    end
end
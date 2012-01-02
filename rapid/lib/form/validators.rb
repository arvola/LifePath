module Rapid
    module Validators
        def self.value
            @value ||= ""
        end

        def self.value= val
            @value = val
        end

        def self.required
            value.to_s.strip.length > 0
        end

        def self.min_length length
            value.to_s.strip.length == 0 || value.to_s.strip.length >= length
        end

        def self.max_length length
            value.to_s.strip.length <= length
        end
    end

    class Check
        attr_accessor :msg

        def initialize &block
            @block = block
        end

        def call
            if !@msg.nil?
                @block.call ? nil : @msg
            else
                @block.call ? nil : "Form validation failed."
            end
        end

        def set_msg text
            @msg = text if @msg.nil?
        end
    end

    class ValidatorList
        attr_accessor :remember, :def

        def initialize
            @list = []
            @msg = "Form validation failed."
            @remember = true
        end

        def validate value
            Validators.value = value
            messages = []

            @list.each do |v|
                temp = v.call
                messages << temp if temp
            end

            messages
        end

        def msg text
            @list.each do |v|
                v.set_msg text
            end
            self
        end

        def no_memory
            @remember = false
            self
        end

        def required
            @list << Check.new { Validators.required }
            self
        end

        def min_length n
            @list << Check.new { Validators.min_length n }
            self
        end

        def max_length n
            @list << Check.new { Validators.max_length n }
            self
        end

        def default value
            @def = value
        end
    end
end
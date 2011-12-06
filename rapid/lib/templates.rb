require 'json'

module Rapid
    class TemplateScope
        attr_accessor :javascript

        def initialize
            @javascript = {}
        end

        def js_vars
            JSON.generate @javascript
        end
    end
end
# LifePath
#
# Author:: Mikael Arvola
# License:: MIT

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

        def script src
            '<script type="text/javascript" src="' + src + '"></script>'
        end
        def css src

        end
    end
end
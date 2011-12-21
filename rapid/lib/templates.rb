# LifePath
#
# Author:: Mikael Arvola
# License:: MIT

require 'json'
require 'form'

module Rapid
    class TemplateScope
        include FormTools
        attr_accessor :javascript, :template

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
# LifePath
#
# Author:: Mikael Arvola
# License:: MIT

require 'json'
require 'form'

module Rapid
    class TemplateScope
        include FormTools
        attr_accessor :javascript, :template, :data

        def TemplateScope.set_scope scope
            @scope_class = scope
        end

        private
        def initialize input
            @javascript = {}
            @in = input
        end

        public
        def TemplateScope.create input
            if @scope_class
                @scope_class.new input
            else
                TemplateScope.new input
            end
        end

        def js_vars
            JSON.generate @javascript
        end

        def script src
            '<script type="text/javascript" src="' + src + '"></script>'
        end

        def css src

        end

        def get key = nil
            @in.get key
        end
        def post key = nil
            @in.post key
        end

        def render template
            Pages.tilt(template, 'templates/' + template.to_s + '.slim').render(self, @data)
        end
    end
end
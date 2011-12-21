# LifePath
#
# Author:: Mikael Arvola
# License:: MIT

require 'slim'
require 'tilt'
require 'templates'

# Methods for creating pages from templates
module Pages
    def render(template, data = {})
        slim template, data
    end

    @slim_cache = {
            base: Tilt.new('templates/base.slim')
    }
    def self.slim_cache
        @slim_cache
    end
    def scope
        @scope_object ||= Rapid::TemplateScope.new
    end

    def slim_cache
        Pages.slim_cache
    end

    def slim(template, data = {})
        scope.javascript = j
        scope.template = template
        unless slim_cache.has_key? :base
            slim_cache[:base] = Tilt.new('templates/base.slim')
        end
        unless slim_cache.has_key? template
            slim_cache[template] = Tilt.new('templates/' + template.to_s + '.slim')
        end

        slim_cache[:base].render(scope, data) do
            slim_cache[template].render(scope, data)
        end
    end

    class Filter < Temple::HTML::Filter
        def on_multi *exps
            p exps
        end
    end
end
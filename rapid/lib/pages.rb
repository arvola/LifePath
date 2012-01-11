# LifePath
#
# Author:: Mikael Arvola
# License:: MIT

require 'temple'
require 'slim'
require 'tilt'
require 'templates'
Slim::Engine.set_default_options :pretty => true

# Methods for creating pages from templates
module Pages
    def render(template, data = {})
        slim template, data
    end

    @slim_cache = {
            base: Tilt.new('templates/base.slim')
    }
    Dir.glob ($BASE_PATH + "/templates/forms/*.slim") do |file|
        @slim_cache[File.basename(file, ".slim").to_sym] = Tilt.new(file)
    end

    def Pages.slim_cache
        @slim_cache
    end
    def scope
        @scope_object ||= Rapid::TemplateScope.create input
    end

    def slim_cache
        Pages.slim_cache
    end

    def Pages.tilt template, path
        slim_cache[template] ||= Tilt.new(path)
    end
    def tilt template, path
        Pages.tilt template, path
    end

    def slim(template, data = {})
        scope.javascript = j
        scope.template = template
        scope.data = data
        ap scope

        tilt(:base, 'templates/base.slim').render(scope, data) do
            tilt(template, 'templates/' + template.to_s + '.slim').render(scope, data)
        end
    end
end
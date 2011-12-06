# LifePath
#
# Author:: Mikael Arvola
# License:: MIT

module Rapid

    # An object that defines a route for RapidRuby
    class Router
        attr_reader :app, :instance

        # Greater weights get processed later. Light
        # routers are thus prioritized
        attr_accessor :weight

        def initialize (app, &block)
            @block = block
            @app = app
        end

        def == (uri)
            @block.call uri
        end

        def <=> arg
            @weight <=> arg.weight if arg.instance_of? Router
        end
    end

    # Creates a new RapidRuby route and stores it
    def Rapid.new_route (app, &block)
        Rapid.add_route Router.new(app, &block)
    end

    def Rapid.add_route (router)
        @routes = [] unless defined? @routes
        @routes << router
        @routes.sort!
    end

    # Cache routing results, this way there isn't as much worry
    # about having slow routers
    @route_cache = {}

    def Rapid.route uri
        @route_cache[uri] if @route_cache.has_key? uri

        obj = Rapid.find_route uri
        @route_cache[uri] = obj
        obj
    end

    # Routes URIs to RapidRuby applications
    def Rapid.find_route uri
        if defined? @routes
            # Find by returning false, unless the object == uri
            # obj == uri runs the internal router block on uri
            rt = @routes.find do |obj|
                if obj == uri
                    obj
                else
                    false
                end
            end
            # Found a route
            if rt
                rt.app
                # No routes found
            else
                nil
            end
        end
    end
end

class Class
  def subclasses
    ObjectSpace.each_object(Class).select { |klass| klass < self }
  end
end
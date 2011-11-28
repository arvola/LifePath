require 'mvc/controller'

class Mvc < Rapid::Controller
    def initialize

    end
    
    def index_action
        puts "foobar"
    end

    def foo_action
        puts "foofoo"
    end
end
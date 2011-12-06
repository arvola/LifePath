require 'mvc/controller'

class Mvc < Rapid::Controller

    def index_action
        puts render "test"
    end

    def foo_action
        puts "foofoo"
    end
end
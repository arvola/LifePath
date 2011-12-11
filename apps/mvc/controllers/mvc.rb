require 'mvc/controller'
require 'session'

class Mvc < Rapid::Controller

    def index_action
        j['testvar'] = "foobarvar"
        j['testvar2'] = {foo: "bar"}
        puts slim :test, { foo: 0}
        regenerate_session

    end

    def foo_action
        puts "foofoo"
    end
end
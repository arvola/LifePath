require 'mvc/controller'
require 'session'
require 'auth'

class Mvc < Rapid::Controller
    include Rapid

    def index_action
        j['testvar'] = "foobarvar"
        j['testvar2'] = {foo: "bar"}
        puts slim :test, { foo: 0}

    end

    def foo_action
        puts "foofoo"
    end
end
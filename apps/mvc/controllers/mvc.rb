require 'mvc/controller'
require 'session'
require 'auth'
require 'form'

class Mvc < Rapid::Controller
    include Rapid

    def index_action
        data = {foo: 0, id: session.user_id}
        if @app.post?
            msg = LoginForm.validate(post)
            data[:msg] = msg
        end
        session.uuid
        session['type']
        session['test'] = "foo"
        j['testvar'] = "foobarvar"
        j['testvar2'] = {foo: "bar"}
        puts slim :test, data
    end

    def foo_action
        puts "foofoo"
    end
end
require 'mvc/controller'
require 'session'
require 'auth'
require 'form'
require 'user'
require $APPS_PATH + '/ext/scope'

class Mvc < Rapid::Controller
    include Rapid
    TemplateScope.set_scope Scope

    def index_action
        data = {foo: 0, id: session.user_id}
        if @app.post?
            msg = LoginForm.validate(post)
            if (msg.length < 1)
                if user = User.auth(post(:email), post(:pass))
                    data[:msg] = "Welcome back, #{user['email']}"
                    become! user.user_id
                else
                    data[:msg] = "Invalid email or password. "
                end
            else
                data[:msg] = msg
            end
        end

        session['test'] = 'foo'

        j['testvar'] = "foobarvar"
        j['testvar2'] = {foo: "bar"}
        puts slim :test, data
    end

    def register_action
        data = {}
        if @app.post?
            msg = LoginForm.validate(post)
            if (msg.nil? || msg.length < 1)
                user = User.create post(:email)

                if user.nil?
                    data[:message] = "User creation failed."
                else
                    user.start_transaction
                    user['username'] = post :user
                    user.password! post(:pass)
                    user.end_transaction

                    data[:message] = "User created."
                end
            end
        end
        puts slim :user, data
    end
end
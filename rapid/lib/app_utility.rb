# LifePath
#
# Author:: Mikael Arvola
# License:: MIT

require 'mvc/model_loader2'
require 'user'

module Rapid
    module AppUtility
        def m
            @models ||= ModelLoader2.new
        end

        def j
            @javascript ||= {}
        end

        def session
            if @session_info
                return @session_info
            elsif @env['rack.session'].has_key? 'session'
                @session_info = Rapid::Session.new @env['rack.session']['session']
            else
                @session_info = Rapid::Session.new
            end
            @env['rack.session']['session'] = @session_info.uuid
            @session_info
        end

        def regenerate_session
            @session_info = if @session_info.user_id
                Session.create @session_info.user_id
            else
                Session.new
            end

            @env['rack.session']['session'] = @session_info.uuid
        end

        # Returns boolean false if there is no user in the current session,
        # otherwise returns the user object
        def user
            return @user unless @user.nil?

            if (uid = session.user_id)
                @user = User.new uid
            else
                @user = false
            end
        end

        def become! user_id
            session['user_id'] = user_id
            regenerate_session
            self
        end
    end
end

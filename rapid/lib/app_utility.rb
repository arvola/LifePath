# LifePath
#
# Author:: Mikael Arvola
# License:: MIT

require 'mvc/model_loader2'

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
            @session_info = Rapid::Session.create 1
        end
    end
end
# LifePath
#
# Author:: Mikael Arvola
# License:: MIT

require 'database'
require 'transaction'
require 'memcached'

module Rapid
    class Session
        include Transaction

        def initialize uuid = nil
            unless uuid.nil?
                @data = Mem[uuid]
                puts "Read from memcached. "
                puts caller
            end

            unless @data
                puts "Create from database. "
                Database.open "session" do |db|
                    if uuid && BSON::ObjectId.legal?(uuid)
                        @data = db.find_one({"_id" => BSON::ObjectId(uuid)})
                        if @data.nil?
                            @data = {"type" => "temporary"}
                            @uuid = db.insert(@data)
                        else
                            @uuid = @data['_id']
                        end
                    else
                        @data = {"type" => "temporary"}
                        @uuid = db.insert(@data)
                    end
                end
                Mem[uuid] = @data unless uuid.nil?
            end
        end

        def Session.cache
            @cache ||= {}
        end

        def Session.factory uuid
            if cache.has_key? uuid
            end
        end

        def Session.create user_id
            @data = {"type" => "user", "user_id" => user_id}
            Database.open "session" do |db|
                @uuid = db.insert(@data)
            end
            Session.new @uuid.to_s
        end

        def Session.delete uuid
            return unless BSON::ObjectId.legal?(uuid)
            Mem.delete uuid
            Database.open "session" do |db|
                @uuid = db.remove("_id" => BSON::ObjectId(uuid))
            end
        end

        def uuid
            @uuid.to_s
        end

        def [] key
            @data[key]
        end

        def []= key, value
            @data[key] = value
            update "session", {"_id" => @uuid}, {key => value}
            Mem[uuid] = @data
        end

        def user_id
            @data.has_key?('user_id') ? @data['user_id'] : nil
        end

        def end_transaction
            Database.open "session" do |db|
                do_end_transaction db
            end
        end
    end

    module SessionUtils
        def session
            if @session_info
                return @session_info
            elsif @env['rack.session'].has_key? 'session'
                @session_info = Rapid::Session.new @env['rack.session']['session']
            else
                @session_info = Rapid::Session.new
                @env['rack.session']['session'] = @session_info.uuid
            end
            @session_info
        end

        def regenerate_session
            old = @session_info.uuid
            @session_info = if @session_info.user_id
                Session.create @session_info.user_id
            else
                Session.new
            end
            Session.delete old

            if @session_info.uuid.length > 0
                @env['rack.session']['session'] = @session_info.uuid
            end
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
# LifePath
#
# Author:: Mikael Arvola
# License:: MIT

require 'database'
require 'auth'
require 'transaction'

module Rapid
    class User
        include Transaction

        def initialize user_id
            Database.open "user" do |db|
                @data = db.find_one({"_id" => BSON::ObjectId(user_id)})
            end
            @user_id = @data['_id'] unless @data.nil?
        end

        def User.create email
            @data = {"type" => "user", "email" => email}
            uid = nil
            begin
                Database.open "user" do |db|
                    uid = db.insert(@data, {safe: true})
                end
            rescue
                warnlog "Failed to create user: " + $!.message
            end

            if uid.nil?
                nil
            else
                User.new uid.to_s
            end

        end

        def User.for_auth email
            data = nil
            Database.open "user" do |db|
                data = db.find_one({"email" => email}, {:fields => ["email", "password"]})
            end

            return data
        end

        def User.auth email, password
            unless user = User.for_auth(email)
                return nil
            end
            if Auth.password? user, password
                User.new user['_id'].to_s
            else
                nil
            end
        end

        def user_id
            @user_id.to_s
        end

        def [] key
            @data[key]
        end

        def []= key, value
            @data[key] = value
            update "user", {"_id" => @user_id}, {key => value}
        end

        def end_transaction
            Database.open "user" do |db|
                do_end_transaction db
            end
        end

        def password! pass
            self['password'] = Auth.hash pass
            self
        end
    end
end
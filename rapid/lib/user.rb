# LifePath
#
# Author:: Mikael Arvola
# License:: MIT

require 'database'
require 'auth'

module Rapid
    class User
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
                data = db.find_one({"email" => email}, :fields => ["email", "password"])
            end

            return data
        end

        def user_id
            @user_id.to_s
        end

        def [] key
            @data[key]
        end

        def []= key, value
            @data[key] = value
            Database.open "user" do |db|
                db.update({"_id" => @user_id}, {"$set" => {key => value}})
            end
        end

        def password! pass
            self['password'] = Auth.hash pass
            self
        end
    end
end
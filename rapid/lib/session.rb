# LifePath
#
# Author:: Mikael Arvola
# License:: MIT

require 'database'
require 'transaction'

module Rapid
    class Session
        include Transaction

        def initialize uuid = nil
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

        def uuid
            @uuid.to_s
        end

        def [] key
            @data[key]
        end

        def []= key, value
            @data[key] = value
            update "session", {"_id" => @uuid}, {key => value}
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
end
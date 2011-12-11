# LifePath
#
# Author:: Mikael Arvola
# License:: MIT

require 'database'

module Rapid
    class Session
        def initialize uuid = nil
            if uuid
                Database.open "session" do |db|
                    @data = db.find_one({"_id" => BSON::ObjectId(uuid)})
                end
                @uuid = @data['_id']
            else
                Database.open "session" do |db|
                    @data = {"type" => "temporary"}
                    @uuid = db.insert(@data)
                end
            end
            p @data
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
            Database.open "session" do |db|
                db.update({"_id" => @uuid}, {"$set" => {key => value}})
            end
        end
    end
end
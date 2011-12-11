# LifePath
#
# Author:: Mikael Arvola
# License:: MIT

require 'config'
require 'mongo'

module Rapid
    module Database
        def Database.open collection, &block
            conn = Mongo::Connection.new(Config['database']['server'])
            db = conn.db(Config['database']['database']).collection collection

            yield db

            conn.close
        end
    end
end
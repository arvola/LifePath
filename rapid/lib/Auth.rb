# LifePath
#
# Author:: Mikael Arvola
# License:: MIT

require 'database'
require 'bcrypt'

module Rapid
    module Auth
        include BCrypt

        def Auth.password? user, password
            Password.new(user['password']) == password
        end
        def Auth.hash password
            Password.create(password).to_s
        end
    end
end
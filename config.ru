# LifePath
#
# Author:: Mikael Arvola
# License:: MIT

require 'encrypted_cookie'
use Rack::Session::EncryptedCookie,
    :secret => "\x81\xCBQl\xBC\xD0\x10\f\xCD|\xA6\xBD\xA2;>8"

booter = nil

require File.expand_path(File.dirname(__FILE__)) + '/rapid/bootstrap'

booter = Rapid::RapidBooter.new

run booter.method(:boot)
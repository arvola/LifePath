require File.expand_path(File.dirname(__FILE__)) + '/rapid/bootstrap'

booter = Rapid::RapidBooter.new
run booter.method(:boot)
require 'ruby-prof'
booter = nil
profiling = RubyProf.profile do
    require File.expand_path(File.dirname(__FILE__)) + '/rapid/bootstrap'

    booter = Rapid::RapidBooter.new
end

printer = RubyProf::FlatPrinter.new(profiling)
File.open(File.dirname(__FILE__) + '/prof/boot.txt', 'w') {|f| printer.print(f, {}) }

run booter.method(:boot)
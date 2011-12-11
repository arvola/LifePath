# LifePath
#
# Author:: Mikael Arvola
# License:: MIT

require 'inifile'

module Rapid
    module Config
        # Global master config for basic config values
        @config = IniFile.load($BASE_PATH + '/config/config.ini')

        def self.[] section
            @config[section]
        end
    end

    class AppConfig

    end
end
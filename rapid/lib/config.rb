require 'inifile'

module Rapid
    # Global master config for basic config values
    $BASE_PATH + '/config/config.ini'
    $config = IniFile.load($BASE_PATH + '/config/config.ini')

    class AppConfig
        
    end
end
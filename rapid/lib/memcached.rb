require 'dalli'
require 'config'

module Rapid
    module Mem
        @conf = Rapid::Config['memcached']
        @server = @conf['server']
        @prefix = @conf['prefix']

        def Mem.[]= key, value
            client.set(@prefix + key, value)
        end
        def Mem.[] key
            client.get(@prefix + key)
        end
        def Mem.delete key
            client.delete(@prefix + key)
        end

        def Mem.client
            @client ||= Dalli::Client.new(@server)
        end
    end
end
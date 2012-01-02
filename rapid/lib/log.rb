# LifePath
#
# Author:: Mikael Arvola
# License:: MIT

require 'logger'

# Global standard error log
$logger = Logger.new('log2.txt')

# Global (Object) method for the standard error logging.
# Including the RapidLog module in a class will essentially
# override this behavior.
def debuglog *args
    #$logger.debug(*args)
end

def warnlog *args
    $logger.warn(*args)
end
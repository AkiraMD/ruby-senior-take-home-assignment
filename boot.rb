require 'bundler/setup'

BASE_PATH = File.dirname(File.absolute_path(__FILE__))
$: << BASE_PATH + "/lib"

require 'vandelay'
require 'vandelay/util/cache'
require 'vandelay/util/db'
require 'vandelay/integrations'
require 'vandelay/models'

Vandelay::Util::DB.verify_connection! unless Vandelay::Util::DB.connection_verified?

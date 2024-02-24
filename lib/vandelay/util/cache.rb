require 'redis'

module Vandelay
  module Util
    class Cache
      def self.redis_connection
        Redis.new(host: 'redis', port: 6379)
      end

      def self.get_cached_data(key)
        Vandelay::Util::Cache.redis_connection.get(key)
      end

      def self.set_cached_data(key, value)
        Vandelay::Util::Cache.redis_connection.setex(key, 600, value)
      end
    end
  end
end

require 'redis'
module Vandelay
  module Util
    class Cache
      EXPIRES_IN_SECONDS = 10 * 60

      # your code here
      def self.redis
        @redis ||= Redis.new(host: "host.docker.internal", port: 6387)
      end

      def self.cache_data(key, data)
        Vandelay::Util::Cache.redis.set(key, Marshal.dump(data), ex: EXPIRES_IN_SECONDS)
      end

      def self.get_cached_data(key)      
        Marshal.load(Vandelay::Util::Cache.redis.get(key)) if Vandelay::Util::Cache.redis.get(key)
      end

      def self.key_present?(key)
        Vandelay::Util::Cache.redis.get(key) != nil
      end
    end
  end
end

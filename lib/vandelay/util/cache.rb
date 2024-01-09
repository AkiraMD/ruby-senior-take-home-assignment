require 'redis'

module Vandelay
  module Util
    class Cache
      def initialize
        @redis = Redis.new(host: 'redis')
      end

      def set(key, value, opts={})
        @redis.set(key, value)
        @redis.expire(key, opts[:expiry]) if opts[:expiry]
      end

      def get(key)
        @redis.get(key)
      end

      def exists?(key)
        @redis.exists?(key)
      end
    end
  end
end

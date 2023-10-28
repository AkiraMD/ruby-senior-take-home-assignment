require 'redis'

module Vandelay
  module Util
    class Cache
      def initialize(expiry_seconds)
        @expiry_seconds = expiry_seconds
        @redis = Redis.new(port: 6387)
      end

      def set(key, obj)
        @redis.set(Marshal.dump(obj), ex: @expiry_seconds)
      end

      def get(key)
        serialized_object = @redis.get(key)
        Marshal.load(serialized_object) if serialized_object
      end
    end
  end
end

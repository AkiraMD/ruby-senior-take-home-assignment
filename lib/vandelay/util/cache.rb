require 'redis'
require 'json'

module Vandelay
  module Util
    class Cache
      def initialize
        @redis = Redis.new
      end

      def fetch(key, expiry = 600)
        cached_data = @redis.get(key)
        return JSON.parse(cached_data) if cached_data

        data = yield if block_given?
        @redis.setex(key, expiry, data.to_json) if data
        data
      end
    end
  end
end

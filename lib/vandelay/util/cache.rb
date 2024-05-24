require 'redis'

module Vandelay
  module Util
    class Cache
      attr_reader :redis

      def initialize
        redis_url = Vandelay.config.dig('persistence', 'redis_url')
        @redis = Redis.new(url: redis_url)
      end

      def fetch(key, expires_in: nil, &block)
        raise ArgumentError, 'block must be given!' unless block_given?

        value = redis.get(key)
        cached_value = if value.nil?
                         value = block.call
                         write(key, value, expires_in:)
                         value&.to_json
                       else
                         redis.get(key)
                       end

        JSON.parse(cached_value)
      end

      def write(key, value, expires_in: nil)
        if expires_in.nil?
          redis.set(key, value&.to_json)
        else
          redis.setex(key, expires_in, value&.to_json)
        end
      end

      def delete(key)
        redis.del(key)
      end
    end
  end
end

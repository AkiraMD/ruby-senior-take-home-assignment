require 'redis'

module Vandelay
  module Util
    class Cache
      DEFAULT_EXPIRATION = 600 # 10.minutes

      def self.fetch(key, &block)
        raise ArgumentError.new("Must provide a block to this method!") unless block_given?

        self.new.fetch(key, &block)
      end

      def fetch(key, &block)
        value = redis.get(key)
        
        if value.nil?
          value = block.call
          redis.set(key, value)
          redis.expireat(key, Time.now.to_i + DEFAULT_EXPIRATION)
        end
        
        value
      end

      private

      def redis
        @redis ||= Redis.new(url: 'redis://redis:6379/0')
      end
    end
  end
end

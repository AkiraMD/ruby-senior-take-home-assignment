require 'redis'

module Vandelay
  module Services
    class CacheService

      def initialize(cache_key)
        redis_config = Vandelay.config.dig('persistence', 'redis')
        @cache_key = cache_key
        @client = Redis.new(host: redis_config['host'])
        @expire_in = redis_config['expires_in'].to_i
      end

      def fetch_and_store
        raise 'A block should be given' unless block_given?
        value = @client.get(@cache_key)
        if value.nil?
          value = yield
          @client.setex(@cache_key, @expire_in, value.to_json) unless value.nil?
          value
        else
          JSON.parse(value)
        end
      end
    end
  end
end

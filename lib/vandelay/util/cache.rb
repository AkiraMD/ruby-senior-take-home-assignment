require 'redis'

module Vandelay
  module Util
    class Cache
      def initialize(cache_valid_minutes)
        super()

        @cache_valid_minutes = cache_valid_minutes
        @cache = {}
      end

      def [](key)
        cached_record = @cache[key]

        return nil if cached_record.nil? || cached_value_expired?(cached_record[:timestamp])

        cached_record[:value]
      end

      def []=(key, value)
        @cache[key] = {
          timestamp: Time.now.utc,
          value: value
        }
      end

      def cached_value_expired?(timestamp)
        # Could use active support for this
        timestamp < (Time.now.utc - (@cache_valid_minutes * 60))
      end

      def reset_cache
        @cache = {}
      end
    end
  end
end

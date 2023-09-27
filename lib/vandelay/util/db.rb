require 'pg'
require 'vandelay'

module Vandelay
  module Util
    module DB
      class Connection
        # delegate method calls to underlying connection instance
        def method_missing(method_name, *args, &block)
          @conn.send(method_name, *args, &block)
        end

        def initialize
          @conn = PG.connect(db_url)
        end

        private

        def db_url
          @db_url ||= Vandelay.config.dig('persistence', 'pg_url')
        end
      end

      # A utility method to manage a connection to the db
      #
      # @param [Proc] requires a block to be given
      # @return returns what the given block returns
      def self.with_connection(&block)
        fail ArgumentError, "block must be given!" unless block_given?
        connection = Vandelay::Util::DB::Connection.new
        result = yield(connection)
        connection.close
        result
      end

      def self.verify_connection!
        connection = Vandelay::Util::DB::Connection.new
        puts "Successfully connected to #{connection.db}!"
        @connection_verified = true
        connection.close
      end

      def self.connection_verified?
        @connection_verified ||= false
      end
    end
  end
end

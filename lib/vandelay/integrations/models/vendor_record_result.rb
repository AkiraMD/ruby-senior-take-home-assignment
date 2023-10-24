# frozen_string_literal: true

module Vandelay
  module Integrations
    module Models
      class VendorRecordResult
        # :success | :not_found | :unexpected_error
        attr_reader :response_type

        # VendorRecord | nil
        attr_reader :record

        def self.not_found
          VendorRecordResult.new :not_found
        end

        def self.unexpected_error
          VendorRecordResult.new :unexpected_error
        end

        def self.success(record)
          VendorRecordResult.new :success, record
        end

        def success?
          self.response_type == :success
        end

        def not_found?
          self.response_type == :not_found
        end

        def unexpected_error?
          self.response_type == :unexpected_error
        end

        private

        # @param [VendorRecord | nil] record
        def initialize(type, record = nil)
          super()

          @response_type = type
          @record = record
        end
      end
    end
  end
end

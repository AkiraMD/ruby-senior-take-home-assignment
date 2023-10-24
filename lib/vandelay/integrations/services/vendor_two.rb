# frozen_string_literal: true

require 'net/http'

require_relative '../models/vendor_record_result'
require_relative '../models/vendor_record'
require_relative '../util/rest_client'

module Vandelay
  module Integrations
    module Services
      class VendorTwo
        def initialize
          super

          @rest_client = Integrations::Util::RestClient.new(
            Vandelay.config.dig('integrations', 'vendors', 'two', 'api_base_url'))
        end

        # @param [String] vendor_id
        # @return [Vandelay::Integrations::Models::VendorRecordResult]
        def retrieve_record_for_patient(vendor_id)
          return Integrations::Models::VendorRecordResult.unexpected_error if auth_token.nil?

          response = fetch_patient_record vendor_id, auth_token

          return Integrations::Models::VendorRecordResult.not_found if response.not_found?
          return Integrations::Models::VendorRecordResult.unexpected_error unless response.success?

          Integrations::Models::VendorRecordResult.success VendorRecord.from_vendor_two_response(response.json)
        end

        private

        def auth_token
          @env = Vandelay.config.dig('environment')

          # tests will mock auth token API so do not cache the value
          @auth_token = nil if @env == 'test'

          auth_token_response = fetch_auth_token

          @auth_token = auth_token_response.success? ? auth_token_response.json[:auth_token] : nil
        end

        # @return [Vandelay::Integrations::Util::RestResponse]
        def fetch_auth_token
          @rest_client.get('/auth_tokens/1')
        end

        # @return [Vandelay::Integrations::Util::RestResponse]
        def fetch_patient_record(vendor_id, token)
          @rest_client.get(
            "/records/#{vendor_id}",
            {'Authorization' => "Bearer #{token}"})
        end
      end
    end
  end
end

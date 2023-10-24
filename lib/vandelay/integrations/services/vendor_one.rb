# frozen_string_literal: true

require 'net/http'

require_relative '../models/vendor_record_result'
require_relative '../models/vendor_record'

module Vandelay
  module Integrations
    module Services
      class VendorOne
        ALL_NET_HTTP_ERRORS = [
          Timeout::Error, Errno::EINVAL, Errno::ECONNRESET, EOFError,
          Net::HTTPBadResponse, Net::HTTPHeaderSyntaxError, Net::ProtocolError
        ]

        # @param [String] vendor_id
        # @return [Vandelay::Integrations::Models::VendorRecordResult]
        def retrieve_record_for_patient(vendor_id)
          return Integrations::Models::VendorRecordResult.unexpected_error if auth_token.nil?

          response = fetch_patient_record vendor_id, auth_token

          case response.code
          when '200'
            json_hash = JSON.parse response.body, { symbolize_names: true }

            Integrations::Models::VendorRecordResult.success VendorRecord.from_vendor_one_response(json_hash)
          when '404'
            Integrations::Models::VendorRecordResult.not_found
          else
            Integrations::Models::VendorRecordResult.unexpected_error
          end
        rescue *ALL_NET_HTTP_ERRORS, JSON::ParserError
          # TODO: replace net-http with faraday
          return Integrations::Models::VendorRecordResult.unexpected_error
        end

        private

        def auth_token
          @env = Vandelay.config.dig('environment')

          # tests will mock auth token API so do not cache the value
          @auth_token = nil if @env == 'test'

          @auth_token ||= fetch_auth_token
        end

        def fetch_auth_token
          response = Net::HTTP.get_response(vendor_one_uri '/auth/1')

          return nil if response.code != '200'

          json_hash = JSON.parse response.body, { symbolize_names: true }

          json_hash[:token]
        rescue JSON::ParserError
          return nil
        end

        # @return [Net::HTTPResponse]
        def fetch_patient_record(vendor_id, token)
          Net::HTTP.get_response(
            vendor_one_uri("/patients/#{vendor_id}"),
            {'Authorization' => "Bearer #{token}"})
        end

        def vendor_one_base_url
          @vendor_one_base_url ||= Vandelay.config.dig('integrations', 'vendors', 'one', 'api_base_url')
        end

        def vendor_one_uri(path)
          URI::HTTP.build(host: vendor_one_base_url, path: path)
        end

        # @return [[FalseClass, Object], [TrueClass, nil]]
        def parse_json(string, options = {})
          options[:symbolize_names] = true unless options.has_key?(:symbolize_names)

          [true, JSON.parse(string, options)]
        rescue JSON::ParserError
          [false, nil]
        end
      end
    end
  end
end

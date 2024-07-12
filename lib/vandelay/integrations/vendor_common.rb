require 'uri'
require 'net/http'
require 'json'

module Vandelay
  module Integrations
    module VendorCommon
      def self.fetch_patient_record(vendor_number, endpoint)
        uri = URI.join(base_uri(vendor_number), endpoint)

        request = Net::HTTP::Get.new(uri)
        request['Authorization'] = "Bearer #{fetch_token(vendor_number)}"

        response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == 'https') do |http|
          http.request(request)
        end

        handle_response(response)
      end

      def self.fetch_token(vendor_number)
        routes_data = JSON.parse(File.read("externals/mock_api_#{vendor_number}/routes.json"), symbolize_names: true)
        route = routes_data[:"/#{auth_route(vendor_number)}"]
        uri = URI.join(base_uri(vendor_number), route)

        response = Net::HTTP.get_response(uri)

        if response.is_a?(Net::HTTPSuccess)
          JSON.parse(response.body)['token']
        else
          raise "Failed to fetch auth token: #{response.code} - #{response.message}"
        end
      end

      private

      def self.auth_route(vendor_number)
        vendor_number == 'one' ? 'auth' : 'auth_tokens'
      end

      def self.base_uri(vendor_number)
        "http://#{api_base_url(vendor_number)}#{}"
      end

      def self.api_base_url(vendor_number)
        Vandelay.config.dig("integrations", "vendors", vendor_number, "api_base_url")
      end

      def self.handle_response(response)
        if response.is_a?(Net::HTTPSuccess)
          JSON.parse(response.body)
        else
          raise "Failed to fetch patient record: #{response.code} - #{response.message}"
        end
      end
    end
  end
end

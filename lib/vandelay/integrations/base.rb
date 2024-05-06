require "net/http"
require 'vandelay/services/cache_service'

module Vandelay
  module Integrations
    class Base
      def initialize(patient, url)
        @patient = patient
        @base_url = url
        @cache_service = Vandelay::Services::CacheService.new("patient_record_#{patient.vendor_id}")
      end

      def get_records_from_provider
        @cache_service.fetch_and_store do
          uri = URI.parse(get_patient_url)
          http = Net::HTTP.new(uri.host, uri.port)
          request = Net::HTTP::Get.new(uri.request_uri)
          request["Authorization"] = "Beater: #{get_token}"
          response = http.request(request)
          parsed_body = JSON.parse(response.body)
          get_record_response(parsed_body)
        end
      end

      private

      def get_token
        uri_token = URI.parse(get_token_url)
        response = Net::HTTP.get_response(uri_token)
        parsed_body = JSON.parse(response.body)
        get_token_from_response(parsed_body)
      end
    end
  end
end

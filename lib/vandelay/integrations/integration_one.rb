require 'net/http'
require 'json'

module Vandelay
  module Integrations
    class IntegrationOne < Vandelay::Integrations::Base

      SERVICE_HOST = 'mock_api_one:80'.freeze
      # AUTH_ENDPOINT = ->(id) { "http://#{SERVICE_HOST}/auth/#{id}".freeze }
      AUTH_ENDPOINT = "http://#{SERVICE_HOST}/auth/1".freeze
      PATIENTS_ENDPOINT = "http://#{SERVICE_HOST}/patients".freeze

      protected

      def patient_information(patient)
        {
          province: patient['province'],
          allergies: patient['allergies'],
          num_medical_visits: patient['recent_medical_visits']
        }
      end

      def authentication_endpoint
        # AUTH_ENDPOINT.call(patient_id)
        AUTH_ENDPOINT
      end

      def source_records_endpoint
        PATIENTS_ENDPOINT
      end

      def token_param_name
        'token'.freeze
      end
    end
  end
end

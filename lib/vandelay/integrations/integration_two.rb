require 'net/http'
require 'json'

module Vandelay
  module Integrations
    class IntegrationTwo < Vandelay::Integrations::Base

      SERVICE_HOST = 'mock_api_two:80'.freeze
      AUTH_ENDPOINT = "http://#{SERVICE_HOST}/auth_tokens/1".freeze
      PATIENTS_ENDPOINT = "http://#{SERVICE_HOST}/records".freeze

      protected

      def patient_information(patient)
        {
          province: patient['province_code'],
          allergies: patient['allergies_list'],
          num_medical_visits: patient['medical_visits_recently']
        }
      end

      def authentication_endpoint
        AUTH_ENDPOINT
      end

      def source_records_endpoint
        PATIENTS_ENDPOINT
      end

      def token_param_name
        'auth_token'.freeze
      end
    end
  end
end

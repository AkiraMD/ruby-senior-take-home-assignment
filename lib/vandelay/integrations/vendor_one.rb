require_relative 'api_client_base'

module Vandelay
  module Integrations
    class VendorOne < Vandelay::Integrations::ApiClientBase
      def config_name
        'one'
      end

      def resource_url
        "#{api_base_url}/patients"
      end

      def token_url
        "#{api_base_url}/auth/1"
      end

      def token_name
        'token'
      end

      def get_patient_record(patient_id)
        json = super

        {
          province: json['province'],
          allergies: json['allergies'],
          num_medical_visits: json['recent_medical_visits']
        }
      end
    end
  end
end

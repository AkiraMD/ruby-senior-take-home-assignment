module Vandelay
  module Integrations
    module Vendors
      class One < Vandelay::Integrations::Vendors::Base
        def self.base_url
          Vandelay.config.dig('integrations', 'vendors', 'one', 'api_base_url')
        end

        def self.patient_path
          Vandelay.config.dig('integrations', 'vendors', 'one', 'patient_path')
        end

        private

        def patient_record(response_body)
          Vandelay::Models::PatientRecord.new(
            patient_id: @patient.id,
            province: response_body['province'],
            allergies: response_body['allergies'],
            num_medical_visits: response_body['recent_medical_visits']
          )
        end
      end
    end
  end
end

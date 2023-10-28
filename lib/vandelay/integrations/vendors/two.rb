module Vandelay
  module Integrations
    module Vendors
      class Two < Vandelay::Integrations::Vendors::Base
        def self.base_url
          Vandelay.config.dig('integrations', 'vendors', 'two', 'api_base_url')
        end

        def self.patient_path
          Vandelay.config.dig('integrations', 'vendors', 'two', 'patient_path')
        end

        private

        def patient_record(response_body)
          Vandelay::Models::PatientRecord.new(
            patient_id: @patient.id,
            province: response_body['province_code'],
            allergies: response_body['allergies_list'],
            num_medical_visits: response_body['medical_visits_recently']
          )
        end
      end
    end
  end
end

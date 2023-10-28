require 'net/http'

module Vandelay
  module Integrations
    module Vendors
      class Base
        def self.base_url
          raise NotImplementedError
        end

        def self.patient_path
          raise NotImplementedError
        end

        def initialize(patient)
          @patient = patient
        end

        def fetch_patient_record
          uri = URI(self.class.base_url + sprintf(self.class.patient_path, @patient.vendor_id))
          response = Net::HTTP.get_response(uri)
          return unless response.is_a?(Net::HTTPOK)
          patient_record(JSON.parse(response.body))
        end

        def patient_record(response_body)
          raise NotImplementedError
        end
      end
    end
  end
end

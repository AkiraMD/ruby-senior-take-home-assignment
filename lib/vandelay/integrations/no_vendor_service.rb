require "vandelay/integrations/base"

module Vandelay
  module Integrations
    class NoVendorService < Base
      def get_records_from_provider
        {
          "patient_id": @patient.vendor_id,
          "province": nil,
          "allergies": [],
          "num_medical_visits": nil
        }
      end
    end
  end
end

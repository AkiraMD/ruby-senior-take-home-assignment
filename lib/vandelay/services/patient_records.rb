require 'vandelay/integrations/vendor_one'
require 'vandelay/integrations/vendor_two'

module Vandelay
  module Services
    class PatientRecords
      def retrieve_record_for_patient(patient)
        return nil if patient.records_vendor.nil?

        client = vendor_api_client(patient.records_vendor)
        record = client.get_patient_record(patient.vendor_id)

        {
          patient_id: patient.id
        }.merge(record)
      end

      def vendor_api_client(vendor_name)
        Object.const_get("Vandelay::Integrations::Vendor#{vendor_name.capitalize}").new
      end
    end
  end
end

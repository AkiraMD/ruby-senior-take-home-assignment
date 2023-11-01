require 'vandelay/integrations/vendor_handler'
require 'rest-client'

module Vandelay
  module Services
    class PatientRecords
      def self.retrieve_record_for_patient(patient)
        # Retrieve a patient's record data from a vendor based on its pre-recorded vendor name
        case patient.records_vendor
        when "one"
          patient_record = self.vendor_one_patient_record(patient.id, patient.vendor_id)
        when "two"
          patient_record = self.vendor_two_patient_record(patient.id, patient.vendor_id)
        else
          return {"error": "Vendor not found"}
        end

        return patient_record
      end

      def self.vendor_one_patient_record(patient_id, vendor_patient_id)
        # Retrieve a patient's record data from vendor "one", re-format with a set of output keys
        vendor_record = Vandelay::Integrations::VendorHandler.get_vendor_one_patient_data(vendor_patient_id)
        
        if vendor_record.key?("error")
          return vendor_record
        else
          return {"patient_id": patient_id, "province": vendor_record["province"], "allergies": vendor_record["allergies"], "num_medical_visits": vendor_record["recent_medical_visits"]}
        end
      end

      def self.vendor_two_patient_record(patient_id, vendor_patient_id)
        # Retrieve a patient's record data from vendor "two", re-format with a set of output keys
        vendor_record = Vandelay::Integrations::VendorHandler.get_vendor_two_patient_data(vendor_patient_id)
        
        if vendor_record.key?("error")
          return vendor_record
        else
          return {"patient_id": patient_id, "province": vendor_record["province_code"], "allergies": vendor_record["allergies_list"], "num_medical_visits": vendor_record["medical_visits_recently"]}
        end
      end
    
    end
  end
end
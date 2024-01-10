module Vandelay
  module Services
    class PatientRecords
      INTEGRATIONS = {
        "one" => Vandelay::Integrations::VendorOne::V1::ApiClient.new,
        "two" => Vandelay::Integrations::VendorTwo::V1::ApiClient.new
      }

      def retrieve_record_for_patient(patient)
        patient_record = nil
        if patient.records_vendor.nil? || patient.vendor_id.nil?
          return { status: 422, message: "Missing vendor details. Patient Id: #{patient.id}"}
        end
        key = cache_key(patient)
        if Vandelay::Util::Cache.key_present?(key)
          # Get cached data if available
          patient_record = Vandelay::Util::Cache.get_cached_data(key)
        else
          if INTEGRATIONS[patient.records_vendor]
            # Get record if registered vendor available.
            patient_record = INTEGRATIONS[patient.records_vendor].get_patient_record(patient.vendor_id)
            Vandelay::Util::Cache.cache_data(key, patient_record) if patient_record
          else
            return { status: 422, message: "Invalid Vendor. Patient Id: #{patient.id}, Vendor: #{patient.records_vendor}"}
          end
        end
        return patient_record
      end

      def cache_key(patient)
        "Patient_#{patient.id}_#{patient.records_vendor}_#{patient.vendor_id}"
      end
    end
  end
end
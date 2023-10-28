module Vandelay
  module Services
    class PatientRecords
      def initialize(expiry_seconds)
        @cache = Vandelay::Util::Cache.new(expiry_seconds)
      end

      def retrieve_record_for_patient(patient)
        vendor_integration = patient.vendor_integration
        return unless vendor_integration

        key = "PatientRecord:#{patient.id}"
        patient_record = @cache.get(key)

        unless patient_record
          patient_record = vendor_integration.fetch_patient_record
          @cache.set(key, patient_record)
        end

        patient_record
      end
    end
  end
end

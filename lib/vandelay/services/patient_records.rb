module Vandelay
  module Services
    class PatientRecords
      def retrieve_record_for_patient(patient)
        return nil if patient.records_vendor.respond_to?(:empty?) && patient.records_vendor.empty? || patient.records_vendor.nil?

        integration = Object.const_get("Vandelay::Integrations::Integration#{patient.records_vendor.capitalize}").new
        vendor_results = integration.get_patient_information(patient.vendor_id)
        vendor_results.merge({ patient_id: patient.id }) unless vendor_results.nil?
      end
    end
  end
end
require 'vandelay/util/cache'
require 'vandelay/integrations/v1/vendor_one'
require 'vandelay/integrations/v1/vendor_two'

module Vandelay
  module Services
    class PatientRecords
      attr_reader :patient

      def retrieve_record_for_patient(patient)
        @patient = patient

        # Check for patient vendor details
        return { error: 'Patient Vendors details are not present', status: 422, system_time: Vandelay.system_time_now.iso8601 } if @patient.vendor_id.nil? || @patient.records_vendor.nil?

        # Returns cached patient record if exists
        return JSON.parse(cached_patient_record) if cached_patient_record

        result = nil
        # Determine the appropriate API to access based on the value of records_vendor
        result = Vandelay::Integrations::V1::VendorOne.new.retrieve_patient_record(@patient.vendor_id) if @patient.records_vendor == 'one'
        result = Vandelay::Integrations::V1::VendorTwo.new.retrieve_patient_record(@patient.vendor_id) if @patient.records_vendor == 'two'

        # Add data to the cache of a patient record if result is not nil
        Vandelay::Util::Cache.set_cached_data(@patient.id, result.to_json) unless result.nil?
        JSON.parse(result.to_json)
      end

      private

      def cached_patient_record
        # Retrieve the cached data of a patient by using the patient ID as the cache key
        Vandelay::Util::Cache.get_cached_data(@patient.id)
      end
    end
  end
end

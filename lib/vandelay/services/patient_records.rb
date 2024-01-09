require 'vandelay/Integrations/vendor_one'
require 'vandelay/Integrations/vendor_two'

module Vandelay
  module Services
    class PatientRecords
      def initialize
        @cache = Vandelay::Util::Cache.new
      end

      def retrieve_record_for_patient(patient)
        return { error: "No vendor exists for patient id: #{patient.id}" } if patient.records_vendor.nil?

        @vendor_id = patient.records_vendor
        @vendor_patient_id = patient.vendor_id
        record = fetch_from_cache

        response =
          if @vendor_id == "one"
            {
              patient_id: patient.id,
              province: record['province'],
              allergies: record['allergies'],
              num_medical_visits: record['recent_medical_visits']
            }
          elsif @vendor_id == "two"
            {
              patient_id: patient.id,
              province: record['province_code'],
              allergies: record['allergies_list'],
              num_medical_visits: record['medical_visits_recently']
            }
          end
        response
      end

      private

      def vendor_integration
        if @vendor_id == "one"
          Vandelay::Integrations::VendorOne.new
        elsif @vendor_id == "two"
          Vandelay::Integrations::VendorTwo.new
        end
      end

      def cache_key
        "vendor_#{@vendor_id}_patient_id_#{@vendor_patient_id}"
      end

      def fetch_from_cache
        if @cache.exists?(cache_key)
          value = @cache.get(cache_key)
          JSON.parse(value)
        else
          value = vendor_integration.fetch_patient_record(vendor_patient_id)
          @cache.set(cache_key, value.to_json, expiry: 10_000)
          value
        end
      end
    end
  end
end
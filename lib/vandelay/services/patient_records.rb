require 'vandelay/integrations/vendor_one'
require 'vandelay/integrations/vendor_two'
require 'vandelay/util/cache'

module Vandelay
  module Services
    class PatientRecords
      def initialize(patient)
        @patient = patient
        @cache = Vandelay::Util::Cache.new
      end

      def fetch_records
        @cache.fetch(cache_key) do
          case @patient.records_vendor
          when 'one'
            Vandelay::Integrations::VendorOne.new.fetch_patient_record(@patient.vendor_id)
          when 'two'
            Vandelay::Integrations::VendorTwo.new.fetch_patient_record(@patient.vendor_id)
          else
            raise 'Unknown vendor'
          end
        end
      end

      private

      def cache_key
        "patient_records:#{@patient.id}"
      end
    end
  end
end

require 'vandelay/Integrations/vendor_one'
require 'vandelay/Integrations/vendor_two'

module Vandelay
  module Services
    class PatientRecords
      def retrieve_record_for_patient(patient)
        vendor_id = patient.records_vendor
        vendor_patient_id = patient.vendor_id

        if vendor_id == "one"
          vendor_one = Vandelay::Integrations::VendorOne.new
          record = vendor_one.fetch_patient_record(vendor_patient_id)
          resp = {
            patient_id: patient.id,
            province: record['province'],
            allergies: record['allergies'],
            num_medical_visits: record['recent_medical_visits']
          }
          resp
        elsif vendor_id == "two"
          vendor_two = Vandelay::Integrations::VendorTwo.new
          record = vendor_two.fetch_patient_record(vendor_patient_id)
          resp = {
            patient_id: patient.id,
            province: record['province_code'],
            allergies: record['allergies_list'],
            num_medical_visits: record['medical_visits_recently']
          }
          resp
        end
      end
    end
  end
end
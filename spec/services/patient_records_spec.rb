require 'spec_helper'

RSpec.describe 'Vandelay::Services::PatientRecords', type: :service do
  let(:app) { RESTServer }
  let(:patient_service) { Vandelay::Services::PatientRecords.new }
  let(:vendor_one_patient) { Vandelay::Models::Patient.with_id(2) }
  let(:vendor_two_patient) { Vandelay::Models::Patient.with_id(3) }

  describe "#retrieve_record_for_patient" do
    it "should get correct record for the patient from Vendor One" do      
      response = patient_service.retrieve_record_for_patient(vendor_one_patient)
      expect(response[:patient_id]).to eq('2')
      expect(response[:province]).to eq('QC')
      expect(response[:allergies]).to eq(["work", "conformity", "paying taxes"])
      expect(response[:num_medical_visits]).to eq(1)
    end

    it "should get correct record for the patient from Vendor Two" do      
      response = patient_service.retrieve_record_for_patient(vendor_two_patient)
      expect(response[:patient_id]).to eq('3')
      expect(response[:province]).to eq('ON')
      expect(response[:allergies]).to eq(["hair", "mean people", "paying the bill"])
      expect(response[:num_medical_visits]).to eq(17)
    end
  end
end
require './spec_helper'

RSpec.describe Vandelay::Services::PatientRecords do
  let(:patient_one) { Vandelay::Models::Patient.with_id(1) }
  let(:patient_two) { Vandelay::Models::Patient.with_id(2) }
  let(:patient_three) { Vandelay::Models::Patient.with_id(3) }

  describe 'Returns patient records from both APIs' do
    it 'return error when no vendor details' do
      response = described_class.new.retrieve_record_for_patient(patient_one)
      expect(response[:status]).to eq 422
      expect(response[:error]).to eq 'Patient Vendors details are not present'
    end

    it 'return patient records from vendor one' do
      response = described_class.new.retrieve_record_for_patient(patient_two)
      expect(response['patient_id']).to eq '743'
      expect(response['province']).to eq 'QC'
      expect(response['allergies']).to eq ['work', 'conformity', 'paying taxes']
      expect(response['num_medical_visits']).to eq 1
    end

    it 'return patient records from vendor two' do
      response = described_class.new.retrieve_record_for_patient(patient_three)
      expect(response['patient_id']).to eq '16'
      expect(response['province']).to eq 'ON'
      expect(response['allergies']).to eq ['hair', 'mean people', 'paying the bill']
      expect(response['num_medical_visits']).to eq 17
    end
  end
end

require './spec_helper'

RSpec.describe Vandelay::Integrations::V1::VendorOne do
  let(:patient_vendor_id) { Vandelay::Models::Patient.with_id(2).vendor_id }

  describe 'Vendor One API' do
    it 'return patient record of the vendor' do
      response = described_class.new.retrieve_patient_record(patient_vendor_id)
      expect(response[:patient_id]).to eq '743'
      expect(response[:province]).to eq 'QC'
      expect(response[:allergies]).to eq ['work', 'conformity', 'paying taxes']
      expect(response[:num_medical_visits]).to eq 1
    end
  end
end

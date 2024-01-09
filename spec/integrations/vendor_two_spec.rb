require 'spec_helper'

RSpec.describe 'Vandelay::Integrations::VendorTwo', type: :service do
  let(:app) { RESTServer }
  let(:vendor_two) { Vandelay::Integrations::VendorTwo.new }
  let(:vendor_two_patient) { Vandelay::Models::Patient.with_id(3) }

  describe "#fetch_auth_token" do
    it "should fetch the auth_token from Vendor Two API" do
      response = vendor_two.fetch_auth_token
      expect(response).to eq('349rijed934r8ij123$==')
    end
  end

  describe "#fetch_patient_record" do
    it "should fetch patient record from Vendor Two API for the given patient" do
      response = vendor_two.fetch_patient_record(vendor_two_patient.vendor_id)
      expect(response['province_code']).to eq('ON')
      expect(response['medical_visits_recently']).to eq(17)
    end
  end
end

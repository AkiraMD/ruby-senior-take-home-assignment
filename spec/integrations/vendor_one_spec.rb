require 'spec_helper'

RSpec.describe 'Vandelay::Integrations::VendorOne', type: :service do
  let(:app) { RESTServer }
  let(:vendor_one) { Vandelay::Integrations::VendorOne.new }
  let(:vendor_one_patient) { Vandelay::Models::Patient.with_id(2) }

  describe "#fetch_auth_token" do
    it "should fetch the auth_token from Vendor One API" do
      response = vendor_one.fetch_auth_token
      expect(response).to eq('129e8ry23uhj23948rhu23')
    end
  end

  describe "#fetch_patient_record" do
    it "should fetch patient record from Vendor One API for the given patient" do
      response = vendor_one.fetch_patient_record(vendor_one_patient.vendor_id)
      expect(response['province']).to eq('QC')
      expect(response['recent_medical_visits']).to eq(1)
    end
  end
end

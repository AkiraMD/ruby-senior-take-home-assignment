require 'spec_helper'

RSpec.describe 'Vandelay::REST::Patients', type: :request do
  let(:app) { RESTServer}

  describe "GET /patients/:patient_id/record" do
    it "should get record for the patient" do
      get "/patients/2/record"
      response = JSON.parse(last_response.body)
      expect(response['patient_id']).to eq('2')
      expect(response['province']).to eq('QC')
      expect(response['allergies']).to eq(["work", "conformity", "paying taxes"])
      expect(response['num_medical_visits']).to eq(1)
    end

    it "should return an empty response if no record is found" do
      get "/patients/patient/5"
      response = JSON.parse(last_response.body)
      expect(response['error']).to eq('No record found for id: 5')
    end
  end
end

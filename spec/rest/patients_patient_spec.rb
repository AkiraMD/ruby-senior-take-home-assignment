require 'spec_helper'

RSpec.describe 'Vandelay::REST::PatientsPatient', type: :request do
  let(:app) { RESTServer}

  describe "GET /patients/patient/:id" do
    it "should get record for the patient" do
      get "/patients/patient/1"
      response = JSON.parse(last_response.body)
      expect(response['id']).to eq('1')
      expect(response['full_name']).to eq('Elaine Benes')
    end

    it "should return an empty response if no record is found" do
      get "/patients/patient/5"
      response = JSON.parse(last_response.body)
      expect(response['error']).to eq('No record found for id: 5')
    end
  end
end

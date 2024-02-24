require './spec_helper'

RSpec.describe Vandelay::REST::PatientRecords do
  let(:response) { last_response }
  let(:response_body) { JSON.parse(last_response.body) }

  describe 'GET /patients/:patient_id/record' do
    it 'returns patients details when id is valid' do
      get '/patient/2/record'
      expect(response_body['patient_id']).to eq '743'
      expect(response_body['province']).to eq 'QC'
      expect(response_body['allergies']).to eq ['work', 'conformity', 'paying taxes']
      expect(response_body['num_medical_visits']).to eq 1
    end

    it 'returns 422 when patient vendor details are nil' do
      get '/patient/1/record'
      expect(response_body['status']).to eq 422
      expect(response_body['error']).to eq 'Patient Vendors details are not present'
    end

    it 'returns 404 when patient vendor details are nil' do
      get '/patient/123/record'
      expect(response_body['status']).to eq 404
      expect(response_body['error']).to eq 'Patient not found'
    end

    it 'returns 422 when invalid id is given' do
      get '/patient/rrtr/record'
      expect(response_body['status']).to eq 422
      expect(response_body['error']).to eq 'Invalid Patient Id'
    end
  end
end

require './spec_helper'

RSpec.describe Vandelay::REST::PatientsPatient do
  let(:response) { last_response }
  let(:response_body) { JSON.parse(last_response.body) }
  let(:patient) { Vandelay::Models::Patient.with_id(1)}


  describe 'GET /patients/:id' do
    it 'returns patients details when id is valid' do
      get '/patient/'+patient.id
      expect(response_body['id']).to eq patient.id
      expect(response_body['full_name']).to eq patient.full_name
      expect(response_body['vendor_id']).to eq patient.vendor_id
      expect(response_body['records_vendor']).to eq patient.records_vendor
    end

    it 'returns 404 when id not exists' do
      get '/patient/123'
      expect(response_body['status']).to eq 404
    end

    it 'returns 422 when invalid id is given' do
      get '/patient/rrtr'
      expect(response_body['status']).to eq 422
    end
  end
end

#spec/app_spec.rb
require 'spec_helper.rb'

require 'rack/test'
require_relative '../app.rb'  

describe 'Vandelay REST Patients API' do
  include Rack::Test::Methods

  def app
    Vandelay::REST::Patients
  end

  describe 'GET /patients' do
    it 'returns all patients' do
      get '/patients'
      expect(last_response).to be_ok
      expect(last_response.content_type).to eq('application/json')
      expect(JSON.parse(last_response.body)).to be_an(Array)
    end
  end

  describe 'GET /:id' do
    it 'returns a specific patient' do
      get '/1' 
      expect(last_response).to be_ok
      expect(last_response.content_type).to eq('application/json')
      expect(JSON.parse(last_response.body)).to be_a(Hash)
      expect(JSON.parse(last_response.body)).to include('id', 'full_name', 'date_of_birth')
    end
  end

  describe 'GET /patients/:id/records' do
    it 'returns records for a specific patient' do
      get '/patients/1/records'  
      expect(last_response).to be_ok
      expect(last_response.content_type).to eq('application/json')
      expect(JSON.parse(last_response.body)).to be_an(Array)
    end
  end
end

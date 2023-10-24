# frozen_string_literal: true

RSpec.describe '/patients/:patient_id' do
  subject(:response) { get '/patients/1' }
  subject(:json_response) { JSON.parse(response.body) }

  context 'no patients' do
    it { expect(response).to be_not_found }
    it { expect(response.body).to be_empty }
  end

  context 'patient exists' do
    let!(:patient) { create :patient }

    it { expect(response).to be_ok }

    it 'returns the patient details' do
      expect(json_response).to eq JSON.parse(patient.to_h.to_json)
    end
  end
end

RSpec.describe Vandelay::REST::PatientsPatient do
  let(:json_response) { JSON.parse(last_response.body) }

  describe 'GET /patient/:id' do
    context 'when the patient exists' do
      let(:patient) { Vandelay::Models::Patient.with_id(patient_id) }
      let(:patient_id) { 3 }

      it 'returns the patient' do
        get "/patients/#{patient_id}"

        expect(last_response).to be_ok
        expect(json_response).to eq(patient.to_h)
      end
    end

    context 'when the patient id is not a number' do
      let(:patient_id) { 'nonexistent' }

      it 'returns a 422' do
        get "/patients/#{patient_id}"
        expect(last_response.status).to eq(422)
        expect(json_response).to eq({ 'error' => 'Invalid patient ID' })
      end
    end

    context 'when the patient does not exist' do
      let(:patient_id) { '-1' }

      it 'returns a 404' do
        get "/patients/#{patient_id}"

        expect(last_response.status).to eq(404)
        expect(json_response).to eq({ 'error' => 'Patient not found' })
      end
    end
  end
end

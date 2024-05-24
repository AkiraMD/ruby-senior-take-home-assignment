RSpec.describe Vandelay::REST::PatientsRecord do
  let(:json_response) { JSON.parse(last_response.body) }

  describe 'GET /patient/:id' do
    context 'when the patient exists' do
      let(:patient) { Vandelay::Models::Patient.with_id(patient_id) }

      context 'when patient has no vendor' do
        let(:patient_id) { 1 }

        it 'returns a 404' do
          get "/patients/#{patient_id}/record"

          expect(last_response.status).to eq(404)
          expect(json_response).to eq({ 'error' => 'Patient not found' })
        end
      end

      context 'when patient has vendor one' do
        let(:patient_id) { 2 }

        it 'returns the patient' do
          get "/patients/#{patient_id}/record"

          expect(last_response).to be_ok
          expect(json_response).to eq({
            'patient_id' => '2',
            'province' => 'QC',
            'allergies' => ['work', 'conformity', 'paying taxes'],
            'num_medical_visits' => 1
          })
        end
      end

      context 'when patient has vendor two' do
        let(:patient_id) { 3 }

        it 'returns the patient' do
          get "/patients/#{patient_id}/record"

          expect(last_response).to be_ok
          expect(json_response).to eq({
            'patient_id' => '3',
            'province' => 'ON',
            'allergies' => ['hair', 'mean people', 'paying the bill'],
            'num_medical_visits' => 17
          })
        end
      end
    end

    context 'when the patient id is not a number' do
      let(:patient_id) { 'nonexistent' }

      it 'returns a 422' do
        get "/patients/#{patient_id}/record"
        expect(last_response.status).to eq(422)
        expect(json_response).to eq({ 'error' => 'Invalid patient ID' })
      end
    end

    context 'when the patient does not exist' do
      let(:patient_id) { '-1' }

      it 'returns a 404' do
        get "/patients/#{patient_id}/record"

        expect(last_response.status).to eq(404)
        expect(json_response).to eq({ 'error' => 'Patient not found' })
      end
    end
  end
end

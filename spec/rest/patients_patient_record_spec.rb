# frozen_string_literal: true

RSpec.describe '/patients/:patient_id/record' do
  subject(:response) { get '/patients/1/record' }
  subject(:json_response) { JSON.parse(response.body) }

  context 'no patients' do
    it { expect(response).to have_attributes(status: 404) }
    it { expect(response.body).to be_empty }
  end

  context 'patient exists for records vendor "one"' do
    let!(:patient) do
      create :patient,
             records_vendor: 'one',
             vendor_id: 45
    end

    context 'authentication API is down' do
      before do
        stub_request(:get, 'http://vendor-one/auth/1')
          .to_timeout
      end

      it { expect(response).to have_attributes(status: 503) }
      it { expect(response.body).to be_empty }
    end

    context 'authentication API returns system error' do
      before do
        stub_request(:get, 'http://vendor-one/auth/1')
          .to_return(status: 500)
      end

      it { expect(response).to have_attributes(status: 503) }
      it { expect(response.body).to be_empty }
    end

    context 'authentication API returns token' do
      let(:auth_token) { Faker::Alphanumeric.alphanumeric }

      before do
        stub_request(:get, 'http://vendor-one/auth/1')
          .to_return(status: 200, body: { "id": "1", "token": auth_token }.to_json)

        stub_request(:get, "http://vendor-one/patients/#{patient.vendor_id}")
      end

      it 'uses authentication token in subsequent requests' do
        response

        assert_requested :get, "http://vendor-one/patients/#{patient.vendor_id}",
                         headers: { 'Authorization' => "Bearer #{auth_token}" },
                         times: 1
      end

      context 'patient does not exist in record vendor' do
        before do
          stub_request(:get, "http://vendor-one/patients/#{patient.vendor_id}")
            .to_return(status: 404)
        end

        it { expect(response).to have_attributes(status: 404) }
        it { expect(response.body).to be_empty }
      end

      context 'patient exists in vendor' do
        let(:vendor_record) do
          {
            id: patient.vendor_id,
            full_name: 'Cosmo Kramer',
            dob: '1987-03-18',
            province: 'QC',
            allergies: [
              'work',
              'conformity',
              'paying taxes'
            ],
            recent_medical_visits: 1
          }
        end

        before do
          stub_request(:get, "http://vendor-one/patients/#{patient.vendor_id}")
            .to_return(status: 200, body: vendor_record.to_json)
        end

        it { expect(response).to have_attributes(status: 200) }

        it 'returns the patient record from vendor one' do
          expected_json = {
            'patient_id' => patient.id,
            'province' => 'QC',
            'allergies' => ['work', 'conformity', 'paying taxes'],
            'num_medical_visits' => 1
          }

          expect(json_response).to eq(expected_json)
        end
      end

      context 'vendor API is down' do
        before do
          stub_request(:get, "http://vendor-one/patients/#{patient.vendor_id}")
            .to_timeout
        end

        it { expect(response).to have_attributes(status: 503) }
        it { expect(response.body).to be_empty }
      end

      context 'vendor API returns system error' do
        before do
          stub_request(:get, "http://vendor-one/patients/#{patient.vendor_id}")
            .to_return(status: 500)
        end

        it { expect(response).to have_attributes(status: 503) }
        it { expect(response.body).to be_empty }
      end
    end
  end
end

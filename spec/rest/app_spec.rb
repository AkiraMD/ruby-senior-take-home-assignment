RSpec.describe 'Vandelay API endpoints' do
  def app
    #Sinatra::Application
    RESTServer
  end

  def parsed_body
    JSON.parse(last_response.body)
  end

  before do
    get uri
  end

  context 'api system path' do
    let(:uri) { '/' }

    it "responds with ok status" do
      expect(last_response).to be_ok
      expect(parsed_body['service_name']).to eq("Vandelay Industries")
    end
  end

  context 'api system path' do
    let(:uri) { '/system_status' }

    it "responds with ok status" do
      expect(last_response).to be_ok
    end
  end

  context "/patients endpoint" do
    let(:uri) { '/patients' }

    it "responds with ok status and patient list in response body" do
      expect(last_response).to be_ok
      expect(parsed_body.count).to eq(3)
      expect(parsed_body.map{|x| x['vendor_id']}.compact.sort).to eq(["16", "743"])
    end
  end

  context "/patients/:id endpoint" do

    context 'existing patient' do
      let(:uri) { "/patients/2" }

      it "responds with ok status and a patient data in response body" do
        expect(last_response).to be_ok
        expect(parsed_body['full_name']).to eq("Cosmo Kramer")
        expect(parsed_body['records_vendor']).to eq("one")
      end
    end

    context 'non existing patient' do
      let(:uri) { "/patients/999" }

      it "responds with status 404" do
        expect(last_response.status).to eq(404)
      end
    end
  end

  context "/patients/:id/record endpoint" do
    let(:uri) { "/patients/#{id_patient}/record" }

    context "patient with no vendor record" do
      let(:id_patient) { 1 }

      it "responds with ok status and a nil data in response body" do
        expect(last_response).to be_ok
        expect(parsed_body['patient_id']).to be_nil
        expect(parsed_body['province']).to be_nil
        expect(parsed_body['num_medical_visits']).to be_nil
        expect(parsed_body['allergies']).to be_empty
      end
    end

    context "patient with vendor 'one' record" do
      let(:id_patient) { 2 }

      it "responds with ok status and a record data in response body" do
        expect(last_response).to be_ok
        expect(parsed_body['patient_id']).to eq("743")
        expect(parsed_body['province']).to eq("QC")
        expect(parsed_body['num_medical_visits']).to eq(1)
        expect(parsed_body['allergies']).to eq(["work", "conformity", "paying taxes"])
      end
    end

    context "patient with vendor 'two' record" do
      let(:id_patient) { 3 }

      it "responds with ok status and a record data in response body" do
        expect(last_response).to be_ok
        expect(parsed_body['patient_id']).to eq("16")
        expect(parsed_body['province']).to eq("ON")
        expect(parsed_body['num_medical_visits']).to eq(17)
        expect(parsed_body['allergies']).to eq(["hair", "mean people", "paying the bill"])
      end
    end

    context 'invalid patient' do
      let(:id_patient) { 'xxx' }

      it "responds with status 400" do
        expect(last_response.status).to eq(400)
      end
    end

    context 'non existing patient' do
      let(:id_patient) { '999' }

      it "responds with status 404" do
        expect(last_response.status).to eq(404)
      end
    end
  end
end

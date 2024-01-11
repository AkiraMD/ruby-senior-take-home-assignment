require_relative '../../../test_helper'

class PatientsPatientRecordTest < RestServerTest
  def test_it_returns_patient_record
    get '/patients/2/record'
    assert last_response.ok?
    assert_equal ({
      "patient_id": "743",
      "province": "QC",
      "allergies": ["work", "conformity", "paying taxes"],
      "num_medical_visits": 1
    }.to_json), last_response.body
  end

  def test_missing_patient
    get '/patients/5/record'
    assert last_response.ok?
    assert_equal 404, JSON.parse(last_response.body)["status"]
    assert_equal "Patient not found", JSON.parse(last_response.body)["message"]
  end

  def test_patient_with_missing_vendor
    get '/patients/1/record'
    assert last_response.ok?
    assert_equal 422, JSON.parse(last_response.body)["status"]
    assert_equal "Missing vendor details. Patient Id: 1", JSON.parse(last_response.body)["message"]
  end
end

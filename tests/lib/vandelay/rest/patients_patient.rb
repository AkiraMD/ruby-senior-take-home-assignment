require_relative '../../../test_helper'

class PatientsPatientTest < RestServerTest
  def test_it_returns_patient
    get '/patients/2'
    assert last_response.ok?
    assert_equal ({
      "id":"2",
      "full_name":"Cosmo Kramer",
      "date_of_birth":"1987-03-18",
      "records_vendor":"one",
      "vendor_id":"743"
    }.to_json), last_response.body
  end

  def test_error_for_missing_id
    get '/patients/5'
    assert last_response.ok?
    assert_equal 404, JSON.parse(last_response.body)["status"]
    assert_equal "Patient not found", JSON.parse(last_response.body)["message"]
  end

  def test_error_for_invalid_id
    get '/patients/okok'
    assert last_response.ok?
    assert_equal 422, JSON.parse(last_response.body)["status"]
    assert_equal "Invalid patient id", JSON.parse(last_response.body)["message"]
  end
end

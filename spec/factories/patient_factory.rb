require 'faker'
require_relative '../../lib/vandelay/models/patient'

FactoryBot.define do
  factory :patient, class: Vandelay::Models::Patient  do
    sequence(:id, &:to_s)
    full_name { Faker::Name.name }
    date_of_birth { Faker::Date.birthday }
    records_vendor { Faker::App.name }
    vendor_id { Faker::Number.number.to_s }
  end
end

# frozen_string_literal: true

require 'factory_bot'
require 'sequel'

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods

  config.before :suite do
    FactoryBot.definition_file_paths = %w{./factories ./test/factories ./spec/factories}
    FactoryBot.find_definitions
  end

  config.before :each do
    FactoryBot.reload

    FactoryBot.define do
      to_create do |obj, _context|
        db = Sequel.connect(Vandelay.config.dig('persistence', 'pg_url'))
        db[:patients].insert(obj.to_h)
      end
    end
  end
end

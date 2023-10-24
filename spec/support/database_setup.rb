# frozen_string_literal: true

require 'database_cleaner-sequel'
require 'sequel'
require_relative '../../lib/vandelay'

RSpec.configure do |config|
  DatabaseCleaner[:sequel].strategy = :truncation
  DatabaseCleaner[:sequel].db = Sequel.connect(Vandelay.config.dig('persistence', 'pg_url'))

  config.before :suite do
    # wipe database with truncation at start of test suite run
    DatabaseCleaner[:sequel].clean_with :truncation
  end

  config.before :each do
    # start transaction
    DatabaseCleaner[:sequel].start
  end

  config.after :each do
    # rollback transaction
    DatabaseCleaner[:sequel].clean
  end
end

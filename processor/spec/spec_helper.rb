require 'webmock/rspec'
require_relative '../config/db'

# TODO: start / stop container for tests
# docker run -d --name dynamodb -p 8000:8000 dwmkerr/dynamodb
Dynamoid.configure do |config|
  config.namespace = 'manifester_test'
  config.endpoint  = "http://localhost:#{ENV.fetch('MANIFESTER_DDB_LOCAL_PORT', 8000)}"
end

RSpec.configure do |config|
  config.color = true

  config.before(:suite) do
    # DynamoidSetup.tests
  end

  config.after(:suite) do
    # DynamoidDestroy.all
  end
end

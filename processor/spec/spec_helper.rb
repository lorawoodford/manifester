require 'webmock/rspec'
require_relative '../config/db'

WebMock.disable_net_connect!(allow_localhost: true)

Dynamoid.configure do |config|
  config.namespace = 'manifester_test'
end

RSpec.configure do |config|
  config.color = true

  config.before(:suite) do
    DynamoidSetup.tests
  end

  config.after(:suite) do
    DynamoidDestroy.all
  end
end

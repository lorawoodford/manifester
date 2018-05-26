require_relative '../config/db'

if ENV.fetch('MANIFESTER_ENV', 'development') == 'production'
  raise 'Tests should not run in production environment!'
end

RSpec.configure do |config|
  config.color = true

  # config.before(:suite) do
  #   DynamoidReset.all
  # end
end

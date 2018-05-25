require 'dynamoid'

Dynamoid.configure do |config|
  config.access_key = ENV.fetch('AWS_ACCESS_KEY_ID')
  config.secret_key = ENV.fetch('AWS_SECRET_ACCESS_KEY')
  config.region     = ENV.fetch('AWS_REGION', 'us-west-2')
  config.namespace  = "manifester_#{ENV.fetch('MANIFESTER_ENV', 'development')}"
end

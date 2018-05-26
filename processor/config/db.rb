require 'aws-sdk'
require 'dynamoid'

Dynamoid.configure do |config|
  config.access_key = ENV.fetch('MANIFESTER_AWS_ACCESS_KEY_ID')
  config.secret_key = ENV.fetch('MANIFESTER_AWS_SECRET_ACCESS_KEY')
  config.region     = ENV.fetch('MANIFESTER_AWS_REGION', 'us-west-2')
  config.namespace  = "manifester_#{ENV.fetch('MANIFESTER_ENV', 'development')}"
end

# load models
require_relative '../model/file'
require_relative '../model/site'

# https://github.com/Dynamoid/Dynamoid#test-environment
module DynamoidDestroy
  def self.all
    Dynamoid.adapter.list_tables.each do |table|
      # Only delete tables in our namespace
      if table =~ /^#{Dynamoid::Config.namespace}/
        Dynamoid.adapter.delete_table(table)
      end
    end
  end
end

# create tables for models
module DynamoidSetup
  def self.all
    Dynamoid.included_models.each(&:create_table)
  end
end

# Reduce noise in test output
Dynamoid.logger.level = Logger::FATAL

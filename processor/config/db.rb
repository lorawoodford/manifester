require 'active_support/core_ext/time'
require 'aws-sdk'
require 'curb'
require 'dynamoid'
require 'tempfile'
require 'time'

Dynamoid.configure do |config|
  env = ENV.fetch('MANIFESTER_ENV', 'development')
  grp = ENV.fetch('MANIFESTER_GRP', 'general')

  config.access_key = ENV.fetch('MANIFESTER_AWS_ACCESS_KEY_ID')
  config.secret_key = ENV.fetch('MANIFESTER_AWS_SECRET_ACCESS_KEY')
  config.region     = ENV.fetch('MANIFESTER_AWS_REGION', 'us-west-2')
  config.namespace  = "manifester_#{grp}_#{env}"

  if env != 'production'
    config.endpoint = "http://localhost:#{ENV.fetch('MANIFESTER_DDB_LOCAL_PORT', 8000)}"
    puts "Using DynamoDB local: #{config.endpoint}"
  end
end

# load models
require_relative '../model/file'
require_relative '../model/site'

# load lib
require_relative '../lib/processor/request'
require_relative '../lib/processor/site'

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

  def self.tests
    Dynamoid.included_models.each do |model|
      model.create_table(sync: true)
    end
  end
end

# Reduce noise in test output
Dynamoid.logger.level = Logger::FATAL

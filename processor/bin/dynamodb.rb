#!/usr/bin/env ruby

# start / stop dynamodb local
require 'optparse'

options  = {}
required = ['site']

optparse = OptionParser.new do |opts|
  opts.on('-s', '--[no-]start', 'Start dynamodb') do |start|
    options[:start] = start
  end

  opts.on('-S', '--[no-]stop', 'Stop dynamodb') do |stop|
    options[:stop] = stop
  end
end

optparse.parse!

if options[:start]
  puts 'Starting DynamoDB local'
  system('docker run -d --name dynamodb -p 8000:8000 instructure/dynamo-local-admin')
end

if options[:stop]
  puts 'Stopping DynamoDB local'
  system('docker stop dynamodb && docker rm dynamodb')
end

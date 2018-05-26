#!/usr/bin/env ruby

# processes manifest for $site

require          'bcrypt'
require          'optparse'
require_relative '../lib/db'

options  = {}
required = %w[site manifest name contact email timezone]

optparse = OptionParser.new do |opts|
  opts.on('-s', '--site SITE', 'Site code') do |site|
    options[:site] = site
  end

  opts.on('-m', '--manifest MANIFEST', 'Manifest url') do |manifest|
    options[:manifest] = manifest
  end

  opts.on('-n', '--name NAME', 'Organization name') do |name|
    options[:name] = name
  end

  opts.on('-c', '--contact CONTACT', 'Contact name') do |contact|
    options[:contact] = contact
  end

  opts.on('-e', '--email EMAIL', 'Contact email') do |email|
    options[:email] = email
  end

  opts.on('-t', '--timezone TIMEZONE', 'Organization timezone') do |timezone|
    options[:timezone] = timezone
  end

  opts.on('-u', '--username USERNAME', 'Basic auth username') do |username|
    options[:username] = username
  end

  opts.on('-p', '--password PASSWORD', 'Basic auth password') do |password|
    options[:password] = password
  end
end

optparse.parse!

missing = required.select { |param| options[param].nil? }
unless missing.empty?
  raise OptionParser::MissingArgument, "Required: #{required.join(',')}"
end

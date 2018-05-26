#!/usr/bin/env ruby

# add $site
# ./bin/site.rb \
#   --site="demo" \
#   --manifest="https://archivesspace.lyrasistechnology.org/files/exports/manifest_ead_xml.csv" \
#   --name="LYRASIS" \
#   --contact="Mark Cooper" \
#   --email="example@example.com" \
#   --timezone="US/New_York"

require          'bcrypt'
require          'optparse'
require_relative '../config/db'

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

missing = required.select { |param| options[param.to_sym].nil? }
unless missing.empty?
  raise OptionParser::MissingArgument, "Required: #{missing.join(',')}"
end

data = {
  site: options[:site],
  manifest: options[:manifest],
  name: options[:name],
  contact: options[:contact],
  email: options[:email],
  timezone: options[:timezone],
  username: options[:username],
  password: options[:password]
}

puts "Creating site: #{data.values.join(',')}"
site = Site.new(
  data
)
site.save
puts "Done!"

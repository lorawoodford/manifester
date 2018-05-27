#!/usr/bin/env ruby

require          'bcrypt'
require          'optparse'
require_relative '../config/db'

options      = {}
required_add = %w[site manifest name contact email timezone]
required_del = %w[site]

optparse = OptionParser.new do |opts|
  opts.banner = 'Usage: site.rb [options]'

  opts.on('-a', '--[no-]add', 'Add site') do |a|
    options[:add] = a
  end

  opts.on('-d', '--[no-]delete', 'Delete site') do |d|
    options[:delete] = d
  end

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

unless options[:add] || options[:delete]
  raise OptionParser::MissingArgument, 'Required: --add or --delete [options]'
end

required = options[:add] ? required_add : required_del
missing  = required.select { |param| options[param.to_sym].nil? }
unless missing.empty?
  raise OptionParser::MissingArgument, "Required: #{missing.join(',')}"
end

if options[:add]
  pass = options[:password] ? BCrypt::Password.create(options[:password]) : nil
  data = {
    site: options[:site],
    manifest: options[:manifest],
    name: options[:name],
    contact: options[:contact],
    email: options[:email],
    timezone: options[:timezone],
    status: Manifester::Processor::Request.get_status(options[:manifest]),
    username: options[:username],
    password: pass
  }

  site = Site.where(site: data[:site]).consistent.first
  raise "Skipping duplicate site: #{site.inspect}" if site

  puts "Creating site: #{data.values.join(',')}"
  site = Site.new(
    data
  )
  site.save
  site = Site.where(site: data[:site]).consistent.first
  puts "Done! Created: #{site.site}"
else
  site = options[:site]
  puts "Deleting site: #{site}"

  result = Site.where(site: site).delete_all
  puts "Done! Deleted: #{result.count} items."
end

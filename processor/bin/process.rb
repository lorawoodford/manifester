#!/usr/bin/env ruby

# processes manifest for $site

require          'optparse'
require_relative '../config/db'

options  = {}
required = ['site']

optparse = OptionParser.new do |opts|
  opts.on('-s', '--site SITE', 'Site code') do |site|
    options[:site] = site
  end
end

optparse.parse!

missing = required.select { |param| options[param.to_sym].nil? }
unless missing.empty?
  raise OptionParser::MissingArgument, "Required: #{missing.join(',')}"
end

site = Site.where(site: options[:site]).consistent.first
raise "Site not found: #{options[:site]}" unless site

status = Manifester::Processor::Request.get_status(site.manifest)
if site.status != status
  # update status
end

raise "Manifest error: #{site.manifest},#{status}" unless status == 200

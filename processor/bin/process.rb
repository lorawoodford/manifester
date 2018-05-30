#!/usr/bin/env ruby

# processes manifest for $site

require          'csv'
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

site = Manifester::Processor::Site.find(:site, options[:site]).first
raise "Site not found: #{options[:site]}" unless site

status = Manifester::Processor::Request.get_status(site.manifest)
if site.status != status
  # update status
end

raise "Manifest error: #{site.manifest},#{status}" unless status == 200

begin
  manifest = Manifester::Processor::Request.download(site.manifest)
  CSV.foreach(manifest.path, headers: true, header_converters: :symbol) do |row|
    data = row.to_hash
    file = Manifester::Processor::File.new(site, data)
    if file.exists?
      if file.requires_update?
        file = file.update!
        puts "Updated existing file: #{file.url}"
      end
    else
      file = file.create!
      puts "Created: #{file.url}"
    end
  end
ensure
  manifest.close
  manifest.unlink
end

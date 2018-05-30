module Manifester
  module Processor
    class File
      attr_reader :data, :valid

      def self.delete!(location)
        ::File.where(location: location).delete_all
      end

      def self.find(key, value)
        ::File.where(key => value).all
      end

      def initialize(site, data)
        @data  = prepare(site, data)
        @file  = refresh
        @site  = site
      end

      def create!
        unless exists?
          @file = ::File.new(@data)
          @file.save
        end
        refresh
      end

      def exists?
        @file
      end

      def prepare(site, data)
        # URI.parse(data[:location])
        # Time.parse(data[:updated_at])
        data[:site]       = site.site
        data[:updated_at] = timestamp(site.timezone, data[:updated_at])
        data
      end

      def refresh
        ::File.where(site: @data[:location]).consistent.first
      end

      def timestamp(timezone, updated_at)
        t = Time.parse updated_at
        ActiveSupport::TimeZone.new(timezone).local_to_utc(t).to_i
      end

    end
  end
end

module Manifester
  module Processor
    class File
      attr_reader :data, :file, :location, :site

      def self.delete!(location)
        ManifestFile.where(url: location).delete_all
      end

      def self.find(key, value)
        ManifestFile.where(key => value).all
      end

      def initialize(site, data)
        @location = data[:location]
        @data     = {}.merge(data)
        @file     = nil
        @site     = site
        prepare
      end

      def create!
        unless exists?
          @file = ManifestFile.new(@data)
          @file.save
        end
        refresh
      end

      def exists?
        refresh
      end

      def prepare
        # URI.parse(data[:location])
        # Time.parse(data[:updated_at])
        @data[:url]       = @location
        @data[:site]      = @site.site
        @data[:deleted]   = @data[:deleted] =~ /[Tt](rue)*/ ? true : false
        @data[:timestamp] = timestamp(@site.timezone, @data[:updated_at])

        @data.delete :location
        @data.delete :updated_at
      end

      def refresh
        @file = ManifestFile.where(url: @location).consistent.first
      end

      def requires_update?
        return nil unless @file
        @file.timestamp < @data[:timestamp] or @file.deleted != @data[:deleted]
      end

      def timestamp(timezone, updated_at)
        t = Time.parse updated_at
        TZInfo::Timezone.get(timezone).local_to_utc(t).to_i
      end

      def update!
        # TODO
        @file.update_fields(@data, if: { "timestamp.lt" => @data[:timestamp] })
        refresh
      end

    end
  end
end

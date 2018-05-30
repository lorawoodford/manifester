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

      # Manifester::Processor::File.since timestamp
      def self.since(timestamp)
        query = { 'timestamp.gte' => timestamp, status: 200 }
        if block_given?
          ManifestFile.where(query).all.each do |file|
            yield file
          end
        else
          ManifestFile.where(query).all
        end
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
        @data[:status] = Manifester::Processor::Request.get_status(@data[:url])

        @data.delete :location
        @data.delete :updated_at
      end

      def refresh
        @file = ManifestFile.where(url: @location).consistent.first
      end

      def requires_update?
        return nil unless @file
        update = false
        update = true if @file.timestamp < @data[:timestamp]
        update = true if @file.deleted != @data[:deleted]
        update = true if @file.status != @data[:status]
        update
      end

      def timestamp(timezone, updated_at)
        t = Time.parse updated_at
        TZInfo::Timezone.get(timezone).local_to_utc(t).to_i
      end

      def update!
        @file.update_attributes(@data)
        refresh
      end
    end
  end
end

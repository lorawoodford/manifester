module Manifester
  module Processor
    class Site
      attr_reader :data, :site

      def self.delete!(site)
        ManifestSite.where(site: site).delete_all
      end

      def self.find(key, value)
        ManifestSite.where(key => value).all
      end

      def initialize(data)
        @data = data
        @site = nil
        prepare
      end

      def create!
        unless exists?
          @site = ManifestSite.new(@data)
          @site.save
        end
        refresh
      end

      def exists?
        refresh
      end

      def prepare
        @data[:status] = Manifester::Processor::Request.get_status(@data[:manifest])
      end

      def refresh
        @site = ManifestSite.where(site: @data[:site]).consistent.first
      end
    end
  end
end

require 'curb'
require 'tempfile'

module Manifester
  module Processor
    class Site
      attr_reader :data, :site

      def self.delete!(site)
        ::Site.where(site: site).delete_all
      end

      def self.find(key, value)
        ::Site.where(key => value).all
      end

      def initialize(data)
        @data = data
        @site = refresh
      end

      def create!
        unless exists?
          @site = ::Site.new(@data)
          @site.save
        end
        refresh
      end

      def exists?
        @site
      end

      def refresh
        ::Site.where(site: @data[:site]).consistent.first
      end

    end
  end
end

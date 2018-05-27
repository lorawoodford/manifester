require 'curb'

module Manifester
  module Processor
    # perform http requests
    module Request
      # Manifester::Processor::Request.get_status(url)
      def self.get_status(url)
        status = 200
        c = Curl::Easy.new(url) { |curl| curl.head = true }
        begin
          c.perform
          status = c.response_code
        rescue Exception => ex
          puts "#{ex.message}: #{url}"
          status = 523 # Origin Is Unreachable
        end
        status
      end
    end
  end
end

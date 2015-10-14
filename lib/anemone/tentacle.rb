require 'anemone/http'

module Anemone
  class Tentacle

    #
    # Create a new Tentacle
    #
    def initialize(link_queue, page_queue, opts = {})
      @link_queue = link_queue
      @page_queue = page_queue
      @http = Anemone::HTTP.new(opts)
      @opts = opts
    end

    #
    # Gets links from @link_queue, and returns the fetched
    # Page objects into @page_queue
    #
    def run
      loop do
        link, referer, depth = @link_queue.deq

        break if link == :END

        @http.fetch_pages(link, referer, depth).each { |page| @page_queue << page }

        delay
      end
    end

    private

    def delay
      delay_sec = @opts[:delay]
      if @opts[:delay].respond_to?(:call)
        delay_sec = @opts[:delay].call
      end
      sleep delay_sec if delay_sec.to_f > 0.0
    end

  end
end

require 'net/http'
require 'rss/2.0'

module NewsAgg
  module Parser
    class Rss
      include Cleaner
      attr_accessor :medium_key, :feed_urls

      def initialize(medium_key, feed_urls)
        @medium_key = medium_key
        @feed_urls = feed_urls
      end

      def items
        items = []
        feed_urls.each do |feed_url|
          rss_items = fetch_rss_items(feed_url)
          rss_items.each { |item| items << parse(item) }
        end
        items
      end

      private
        def parse(item)
          object = {}
          object[:medium_key]  = medium_key
          object[:title]       = clean_whitespace(item.title)
          object[:timestamp]   = item.date.to_i || item.pubDate.to_i
          object[:description] = clean_whitespace(item.description)
          object[:url]         = clean_whitespace(item.link)

          # DEBUG: feed_url object
          # p object[:url]

          object
        end

        def fetch_rss_items(feed_url)
          if feed_url =~ URI::regexp
            begin
              # TODO: handle exceptions properly
              uri = URI.parse(feed_url)
              response = Net::HTTP.get_response(uri)
              RSS::Parser.parse(response.body, false).items
            rescue OpenURI::HTTPError
              []
            end
          else
            []
          end
        end
    end
  end
end

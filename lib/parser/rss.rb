require 'net/http'
require 'rss/2.0'

module NewsAgg
  module Parser
    class Rss
      attr_accessor :name, :feeds

      def initialize(name, feeds)
        @name = name
        @feeds = feeds
      end

      def items
        items = []
        feeds.each do |feed|
          rss = fetch_rss(feed)
          rss.items.each { |item| items << parse(item) }
        end
        items
      end

      private
        def parse(item)
          {
            :medium => name,
            :title => item.title,
            :date => item.date.to_i || item.pubDate.to_i,
            :url => item.guid.content || item.link,
            :description => item.description
          }
        end

        def fetch_rss(feed)
          # TODO: handle exceptions properly
          response = Net::HTTP.get_response(URI.parse(feed))
          RSS::Parser.parse(response.body, false)
        end
    end
  end
end

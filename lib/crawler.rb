module NewsAgg
  class Crawler
    attr_accessor :medium

    def initialize(medium)
      @medium = medium
    end

    def process
      feed_items.each do |feed_item|
        item = Item.new(feed_item)

        unless item.exists?
          html_parser  = NewsAgg::Parser::Html.new(item.url, medium.selector)
          item.content = html_parser.content

          item.save
        end
      end
    end

    private
      def feed_items
        parser = NewsAgg::Parser::Rss.new(medium.key, medium.feeds)
        parser.items
      end
  end
end

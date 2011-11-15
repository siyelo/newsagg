module NewsAgg
  class Crawler
    attr_accessor :medium

    def initialize(medium)
      @medium = medium
    end

    def items
      feed_items.each do |item|
        html_parser = NewsAgg::Parser::Html.new(item[:url], medium.selector)
        item[:content] = html_parser.content
      end
    end

    private
      def feed_items
        parser = NewsAgg::Parser::Rss.new(medium.url, medium.feeds)
        # TODO: change to return all items
        [parser.items[0]]
      end
  end
end

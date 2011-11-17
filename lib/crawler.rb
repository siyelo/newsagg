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
          parser  = NewsAgg::Parser::Html.new(item.url, medium.selector)
          item.content = parser.content
          item.save
        end
      end

      Item.clean_old_items!

      # DEBUG
      # item = Item.find("item:timeslive.co.za:1321459262")
      # Classifier.classify(item)
    end

    def self.start
      Medium.all.each do |medium|
        crawler = Crawler.new(medium)
        crawler.process
      end
    end

    private
      def feed_items
        parser = NewsAgg::Parser::Rss.new(medium.key, medium.feeds)
        parser.items
      end
  end
end

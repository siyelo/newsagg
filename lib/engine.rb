require_relative '../config'
require_relative 'medium'
require_relative 'parser'
require_relative 'crawler'

module NewsAgg
  module Engine
    class << self
      def start
        $media.each do |medium_params|
          medium  = NewsAgg::Medium.new(medium_params)
          crawler = NewsAgg::Crawler.new(medium)
          items   = crawler.items
          save(items)
        end
      end

      def save(items)
        items.each do |item|
          # TODO: save items in Redis
          p item[:medium]
          p item[:title]
          p item[:date]
          p item[:url]
          p item[:description]
          p item[:content]
        end
      end
    end
  end
end

NewsAgg::Engine.start

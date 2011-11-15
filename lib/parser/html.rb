require 'open-uri'
require 'nokogiri'

module NewsAgg
  module Parser
    class Html
      attr_accessor :url, :selector

      def initialize(url, selector)
        @url      = url
        @selector = selector
      end

      def content
        content = []
        # TODO: handle exceptions properly
        doc = Nokogiri::HTML(open(url))
        doc.search(selector).each do |element|
          content << remove_extra_whitespace(element.text)
        end
        content
      end

      private
        def remove_extra_whitespace(text)
          text.gsub(/\s{2,}|\t|\n/, ' ').strip
        end
    end
  end
end

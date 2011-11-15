require 'open-uri'
require 'nokogiri'

module NewsAgg
  module Parser
    class Html
      include Cleaner
      attr_accessor :url, :selector

      def initialize(url, selector)
        @url      = url
        @selector = selector
      end

      def content
        content = []
        html_elements = fetch_html_elements(url)
        html_elements.each { |element| content << clean_whitespace(element.text) }
        content.join(' ')
      end

      private

        def fetch_html_elements(url)
          if url =~ URI::regexp
            # TODO: handle exceptions properly
            begin
              # DEBUG: URL
              # p url
              doc = Nokogiri::HTML(open(url))
              doc.search(selector)
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

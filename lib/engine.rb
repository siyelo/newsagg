path = File.expand_path('../../lib', __FILE__)
$:.unshift(path) if File.directory?(path) && !$:.include?(path)

require_relative '../config'

module NewsAgg

  autoload :Item, 'item'
  autoload :Medium, 'medium'
  autoload :Crawler, 'crawler'

  module Parser
    autoload :Rss, 'parser/rss'
    autoload :Html, 'parser/html'
    autoload :Cleaner, 'parser/cleaner'
  end

  module Engine
    def self.start
      $media.each do |medium_params|
        medium  = Medium.new(medium_params)
        crawler = Crawler.new(medium)
        crawler.process
      end
    end
  end
end

NewsAgg::Engine.start

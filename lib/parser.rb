path = File.expand_path('../../lib/parser', __FILE__)
$:.unshift(path) if File.directory?(path) && !$:.include?(path)

module NewsAgg
  module Parser
    autoload :Rss,     'rss'
    autoload :Html,    'html'
    autoload :Cleaner, 'cleaner'
  end
end

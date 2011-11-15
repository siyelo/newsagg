path = File.expand_path('../parser', __FILE__)
$:.unshift(path) if File.directory?(path) && !$:.include?(path)

module NewsAgg
  module Parser
    autoload :Rss, 'rss'
    autoload :Html, 'html'
  end
end

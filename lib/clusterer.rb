path = File.expand_path('../../lib/clusterer', __FILE__)
$:.unshift(path) if File.directory?(path) && !$:.include?(path)

require 'json'

module NewsAgg
  module Clusterer
    autoload :StatsCluster, 'stats_cluster'
  end
end

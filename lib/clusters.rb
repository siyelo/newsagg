require 'json'
module NewsAgg
  module Clusters
    class << self

      def create!
        # DEBUG
        p "clustering items..."

        items = NewsAgg::Item.find(R.keys('item*'))
        texts = items.map{|item| item.content}
        clusterer = NewsAgg::Clusterer::StatsCluster.new
        clusters_ids = clusterer.clusterize(texts)

        clusters_items = []
        clusters_ids.each do |cluster_ids|
          clusters_items << cluster_ids.map{|id| items[id].key}
        end

        R['clusters'] = clusters_items.to_json
      end

      def load
        clusters_data = R['clusters']
        if clusters_data
          clusters_ids = JSON.parse(clusters_data)
          clusters_ids.map{|cluster_ids| Item.find(cluster_ids)}
        else
          []
        end
      end
    end
  end
end


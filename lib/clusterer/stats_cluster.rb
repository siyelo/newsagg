module NewsAgg
  module Clusterer
    # Word-Use Intersections
    class StatsCluster
      THRESHOLD = 0.3
      attr_accessor :noise_words

      def initialize
        filename = File.join(File.dirname(__FILE__), '..', 'data', 'stop_words.txt')
        @noise_words = File.new(filename).readlines.map(&:chomp)
      end

      def clusterize(texts)
        words_matrix = texts.map { |text| text.downcase.scan(/[a-z]+/) - noise_words }
        similarity_matrix = calculate_similarity_matrix(words_matrix)
        calculate_clusters(similarity_matrix)
      end

      # similarity score between two texts
      # used only for debugging
      def texts_score(text1, text2)
        words1 = text1.downcase.scan(/[a-zA-Z]+/) - noise_words
        words2 = text2.downcase.scan(/[a-zA-Z]+/) - noise_words
        common_words = words1 & words2
        p common_words
        common_words.length.to_f / (words1.length + words2.length)
      end

      private

        def similarity_score(words1, words2)
          common_words = words1 & words2
          2.0 * common_words.length.to_f / (words1.length + words2.length)
        end

        def calculate_similarity_matrix(words_matrix)
          # initialize similarity matrix with 0
          size = words_matrix.length
          similarity_matrix = size.times.map { Array.new(size, 0) }

          # calculate similarity matrix between all texts
          size.times do |i|
            size.times do |j|
              similarity_matrix[i][j] = similarity_score(words_matrix[i], words_matrix[j])
            end
          end

          similarity_matrix
        end

        def calculate_clusters(similarity_matrix)
          clusters = []
          size     = similarity_matrix.length

          size.times do |i|
            similar = []

            # find similar texts to i
            size.times do |j|
              similar << j if j > i && similarity_matrix[i][j] > THRESHOLD
            end

            # add i to array of similar texts
            if similar.length > 0
              similar << i
              clusters << similar.sort # sort the array
            end
          end

          # remove redundent clusters:
          clusters.size.times do |i|
            clusters.size.times do |j|
              if clusters[j].length < clusters[i].length
                clusters[j] = [] if (clusters[j] & clusters[i]) == clusters[j]
              end
            end
          end

          clusters.select{ |c| c.length > 1 }
        end

    end
  end
end

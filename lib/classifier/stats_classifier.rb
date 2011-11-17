module NewsAgg
  module Classifier
    class StatsClassifier
      attr_accessor :training_sets

      def initialize(data)
        @training_sets = {}
        filename = File.join(File.dirname(__FILE__), '..', 'data', 'stop_words.txt')
        @noise_words = File.new(filename).readlines.map(&:chomp)

        train(data)
      end

      def scores(text)
        words = text.downcase.scan(/[a-z]+/)

        scores = {}
        training_sets.each_pair do |category, word_weights|
          scores[category] = score(word_weights, words)
        end

        scores
      end

      def train(data)
        data.each_pair do |category, text|
          words = text.downcase.scan(/[a-z]+/)
          word_weights = Hash.new(0)

          words.each {|word| word_weights[word] += 1 unless @noise_words.index(word)}

          ratio = 1.0 / words.length
          word_weights.keys.each {|key| word_weights[key] *= ratio}

          training_sets[category] = word_weights
        end
      end

      private
        def score(word_weights, words)
          score = words.inject(0) {|acc, word| acc + word_weights[word]}
          1000.0 * score / words.size
        end
    end
  end
end

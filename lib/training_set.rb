module NewsAgg
  class TrainingSet
    attr_accessor :category, :content

    def initialize(category, content)
      @category = category
      @content  = content
    end

    def save
      # DEBUG: training set
      p "saving training set... category => #{category}"
      k = self.class.key(category)
      R.hmset(k, 'category', category)
      R.hmset(k, 'content', content)
    end

    def self.find(category)
      params = R.hgetall(key(category))
      TrainingSet.new(params['category'], params['content'])
    end

    private
      def self.key(category)
        "training_set:#{category}"
      end
  end
end

module NewsAgg
  class Item
    attr_accessor :medium_key, :title, :timestamp,
      :url, :content, :scores, :category

    def initialize(params)
      @medium_key  = params['medium_key']
      @title       = params['title']
      @timestamp   = params['timestamp']
      @url         = params['url']
      # @description = params['description']
      @content     = params['content']

      load_associations
    end

    def save
      # persist the item only if it has content. some media items are
      # displayed in their feeds but they cannot be accessed on the site (!?)
      return if content.blank?

      unless exists?
        save_item
        Classifier.classify(self)
      else
        # use different timestamp if other item exists with the same timestamp
        unless title_same?
          timestamp += 1
          # save_item
          save
        end
      end
    end

    def exists?
      R.exists(key)
    end

    def title_same?
      R.hget(key, 'title') == title
    end

    def key
      # don't cache this string,
      # timestamp change is used to produce original key
      "item:#{medium_key}:#{timestamp}"
    end

    def add_scores(scores)
      # redis: string
      R.set("scores:#{key}", scores.to_json)
    end

    def destroy
      R.multi do
        category.remove_item(self)
        remove_scores
        delete_item
        # TODO: remove item from clusters
      end
    end

    def self.find(key)
      if key.is_a?(Array)
        key.map { |k| Item.find(k) }
      else
        new(R.hgetall(key))
      end
    end

    private

      def save_item
        # DEBUG: saved object
        p "saving... medium => #{medium_key}, key => #{key}, title => #{title}"

        k = key
        R.hmset(k, 'medium_key', medium_key)
        R.hmset(k, 'title', title)
        R.hmset(k, 'timestamp', timestamp)
        R.hmset(k, 'url', url)
        # R.hmset(k, 'description', description)
        R.hmset(k, 'content', content)
      end

      def delete_item
        R.del(key)
      end

      def remove_scores
        R.del("scores:#{key}")
      end

      def load_associations
        @scores   = load_scores
        @category = load_category
      end

      def load_scores
        scores = R.get("scores:#{key}")
        if scores
          JSON.parse(scores)
        else
          []
        end
      end

      def load_category
        category_name, score = scores.max_by{ |k,v| v }
        Category.find(category_name)
      end
  end
end

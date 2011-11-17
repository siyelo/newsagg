module NewsAgg
  class Item
    attr_accessor :medium_key, :title, :timestamp,
      :url, :content, :scores#, :description

    def initialize(params)
      @medium_key  = params['medium_key']
      @title       = params['title']
      @timestamp   = params['timestamp']
      @url         = params['url']
      # @description = params['description']
      @content     = params['content']
      @scores      = params['scores']
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


    def self.find(key)
      if key.is_a?(Array)
        key.map { |k| Item.find(k) }
      else
        scores = R.get("score:#{key}")
        scores = JSON.parse(scores)
        new(R.hgetall(key).merge('scores' => scores))
      end
    end

    # Redis on Heroku is free up to 5 mb
    # we need to regularly clean "old" items
    # allow max to 50 items per category
    def self.clean_old_items!
      # TODO: clean old items in database
      # leave only 10 items per category
      NewsAgg::Category.all.each do |category|
        # DEBUG
        # deleted = R.zremrangebyrank("category:#{category.name}", 0, -11)
        # p "cleaning... category => #{category.name}, deleted => #{deleted}"
        p "cleaning... category => #{category.name}"
        R.zrevrange("category:#{category.name}", CATEGORY_LIMIT, -1).each do |key|
          R.del("score:#{key}")
          R.zrem("category:#{category.name}", key)
          R.del(key)
        end
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
  end
end

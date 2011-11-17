module NewsAgg
  class Category
    attr_accessor :name, :seeds
    CATEGORY_LIMIT = 15 # max number of items per category

    def initialize(params)
      @name  = params[:name]
      @seeds = params[:seeds]
    end

    # last items ordered by timestamp (redis: ordered set)
    def recent_items(limit = CATEGORY_LIMIT)
      keys = R.zrevrange("category:#{name}", 0, limit - 1)
      @items = Item.find(keys)
    end

    # find older category items (0,1,2,3,[4,5,6,7,8])
    def old_items(limit = CATEGORY_LIMIT)
      keys = R.zrevrange("category:#{name}", limit, -1)
      @items = Item.find(keys)
    end

    def add_item(item, score)
      # redis sorted set: category:name
      R.zadd("category:#{name}", item.timestamp, item.key)
    end

    def remove_item(item)
      R.zrem("category:#{name}", item.key)
    end

    def self.all
      @all ||= CONFIG[:categories].map { |params| new(params) }
    end

    def self.find(name)
      all.detect{ |c| c.name == name }
    end

    # Redis on Heroku is free up to 5 mb
    # keep only fews records per category
    def self.clean_old_items!
      # DEBUG
      p "cleaning old items..."

      all.each do |category|
        category.old_items.each { |item| item.destroy }
      end
    end
  end
end

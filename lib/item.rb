module NewsAgg
  class Item
    attr_accessor :medium_key, :title, :timestamp,
      :url, :description, :content

    def initialize(params)
      @medium_key  = params[:medium_key]
      @title       = params[:title]
      @timestamp   = params[:timestamp]
      @url         = params[:url]
      @description = params[:description]
      @content     = params[:content]
    end

    def save
      # persist the item only if it has content. some media items are
      # displayed in their feeds but they cannot be accessed on the site (!?)
      return if content.blank?

      unless exists?
        save_item
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
      "item:#{medium_key}:#{timestamp}"
    end

    private

      def save_item
        # DEBUG: saved object
        p "saving... key => #{key}, title => #{title}"

        k = key
        R.hmset(k, 'title', title)
        R.hmset(k, 'timestamp', timestamp)
        R.hmset(k, 'url', url)
        R.hmset(k, 'description', description)
        R.hmset(k, 'content', content)
      end
  end
end

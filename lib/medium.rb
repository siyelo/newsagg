module NewsAgg
  class Medium
    attr_accessor :key, :url, :feeds, :selector

    def initialize(params)
      @key      = params[:key]
      @url      = params[:url]
      @feeds    = params[:feeds]
      @selector = params[:selector]
    end
  end
end

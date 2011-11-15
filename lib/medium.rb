module NewsAgg
  class Medium
    attr_accessor :name, :url, :feeds, :selector

    def initialize(params)
      @name     = params[:name]
      @url      = params[:url]
      @feeds    = params[:feeds]
      @selector = params[:selector]
    end
  end
end

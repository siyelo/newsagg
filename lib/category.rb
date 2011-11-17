module NewsAgg
  class Category
    attr_accessor :name, :seeds

    def initialize(params)
      @name  = params[:name]
      @seeds = params[:seeds]
    end

    def self.all
      @all ||= CONFIG[:categories].map { |params| new(params) }
    end
  end
end


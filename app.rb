require './config'

include NewsAgg

get '/' do
  @categories = Category.all
  @category   = Category.find(params[:c])

  if @category
    @items = @category.recent_items
    haml :category, :layout => :layout
  else
    @clusters = Clusters.load
    haml :cluster, :layout => :layout
  end
end

get '/style.css' do
  sass :style
end

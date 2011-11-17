require './config'

include NewsAgg

get '/' do
  params[:c] ||= 'world' # temp until cluster is implemented

  @categories = Category.all
  @category   = Category.find(params[:c])

  if @category
    @items = @category.recent_items
    haml :category, :layout => :layout
  else
    haml :cluster, :layout => :layout
  end
end

get '/style.css' do
  sass :style
end

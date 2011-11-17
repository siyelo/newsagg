require './config'

include NewsAgg

get '/' do
  @categories = Category.all.map(&:name)

  params[:c] ||= 'world' # temp until cluster is implemented

  if @categories.include?(params[:c])
    # display last articles from ordered list scoring by article timestamp
    keys = R.zrevrange("category:#{params[:c]}", 0, CATEGORY_LIMIT - 1)
    @items = Item.find(keys)
    haml :category, :layout => :layout
  else
    haml :cluster, :layout => :layout
  end
end

get '/style.css' do
  sass :style
end

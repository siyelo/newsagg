require './config.rb'

get '/' do
  $r['foo'] = 'bar'
  haml :index
end

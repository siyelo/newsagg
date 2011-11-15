require './config.rb'

get '/' do
  # raise $r.exists('foo').to_yaml
  $r['foo'] = 'bar'
  haml :index
end

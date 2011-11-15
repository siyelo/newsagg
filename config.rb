require "rubygems"
require "bundler/setup"
Bundler.require


# development environment
ENV['RACK_ENV'] ||= 'development'
configure :development do
  ENV["REDISTOGO_URL"] = 'redis://localhost:6379'
end


# production environment
# Heroku sets: ENV['RACK_ENV'] and ENV["REDISTOGO_URL"]


# all environments
configure do
  uri = URI.parse(ENV["REDISTOGO_URL"])
  $r = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
end

$media = YAML::load_file(File.join(File.dirname(__FILE__), 'media.yml'))

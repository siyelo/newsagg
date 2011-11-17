require "rubygems"
require "bundler/setup"
Bundler.require

require_relative 'helpers'
require_relative 'lib/newsagg'
require 'json'


Dir["#{File.dirname(__FILE__)}/lib/core_ext/*.rb"].sort.each do |path|
  require_relative "lib/core_ext/#{File.basename(path, '.rb')}"
end


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
  R = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
end


CONFIG = YAML::load_file(File.join(File.dirname(__FILE__), 'config.yml'))

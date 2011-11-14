require "rubygems"
require "bundler/setup"
Bundler.require

require './app'

run Sinatra::Application

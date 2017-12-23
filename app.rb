require 'rubygems'
require 'bundler'
Bundler.setup
require 'sinatra'
require 'json'
require 'rest-client'
require 'haml'

get '/' do
  'Hello world'
end

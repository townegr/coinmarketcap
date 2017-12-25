require 'rubygems'
require 'bundler'
Bundler.setup
require 'sinatra'
require 'rest-client'
require 'json'
require 'haml'
require 'pry'
require_relative 'helpers/application_helper.rb'

include ApplicationHelper

I18n.enforce_available_locales = false
set :public_folder, File.dirname(__FILE__)

get '/' do
  response = RestClient.get 'https://api.coinmarketcap.com/v1/ticker/'
  @jhash = JSON.parse response
  get_ranges
  haml :index, locals: {response: @jhash}
end

require 'rubygems'
require 'bundler'
Bundler.setup
require 'sinatra'
require 'active_support/all'
require 'json'
require 'haml'
require 'pry'

include ApplicationHelper

I18n.enforce_available_locales = false
set :public_folder, File.dirname(__FILE__)

get '/coins/?:start?' do
  query = Sinatra::IndifferentHash[params.compact]
  response = CoinMarketCapService.call query
  data = JSON.parse response
  get_ranges data
  haml :"coins/index", locals: format_data(data, query)
end

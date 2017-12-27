Dir.glob('./{helpers,models}/*.rb').each { |file| require file }

require 'sinatra/base'
require './app'

run Sinatra::Application

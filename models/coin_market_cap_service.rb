require 'rest-client'

class CoinMarketCapService
  attr_accessor :params
  attr_reader   :client

  def self.call(params = {})
    new(params).()
  end

  def initialize(params = {}, client = RestClient)
    @params = params
    @client = client
  end

  def call
    url = params.present? ? append_params_to_endpoint : endpoint
    client.get url
  end

  private
  def append_params_to_endpoint
    endpoint << format_params
  end

  def format_params
    params[:start] == 'all' ? view_all : view_rank
  end

  def view_all
    '?limit=0'
  end

  def view_rank
    params.map{|k,v| "#{k}=#{v}"}.first.insert(0, '?')
  end

  def endpoint
    'https://api.coinmarketcap.com/v1/ticker/'
  end
end

require 'money'

module ApplicationHelper
  def to_currency(options = {})
    currency = Money.new (self.to_f * 100), 'USD'
    currency.format options.merge(symbol: false)
  end

  def get_ranges
    @min_price, @max_price = @jhash.map{|el| el['price_usd'].to_f}.sort.values_at(0, -1)
    @min_vol, @max_vol     = @jhash.map{|el| el['24h_volume_usd'].to_f}.sort.values_at(0, -1)
    @min_cap, @max_cap     = @jhash.map{|el| el['market_cap_usd'].to_f}.sort.values_at(0, -1)
  end
end

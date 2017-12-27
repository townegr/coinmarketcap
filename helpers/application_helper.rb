require 'money'

module ApplicationHelper
  def format_data(object, params)
    data = {data: object, start: step}
    return data unless params.present?
    data.merge(paginate_by_rank params)
  end

  def paginate_by_rank(params)
    rank = params[:start].to_i
    case
    when rank >= step
      {start: (rank + step), prev: (rank - step)}
    when rank < step
      {start: (rank + step), prev: 0}
    end
  end

  def step
    100
  end

  def to_currency(options = {})
    currency = Money.new (self.to_f * 100), 'USD'
    currency.format options.merge(symbol: false)
  end

  def get_ranges(data)
    @min_price, @max_price = data.map{|el| el['price_usd'].to_f}.sort.values_at(0, -1)
    @min_vol, @max_vol     = data.map{|el| el['24h_volume_usd'].to_f}.sort.values_at(0, -1)
    @min_cap, @max_cap     = data.map{|el| el['market_cap_usd'].to_f}.sort.values_at(0, -1)
  end

  def partial(template, *args)
    options = args.extract_options!
    options.merge!(layout: false)

    if collection = options.delete(:collection)
      collection.inject([]) do |buffer, member|
        buffer << haml(
          template,
          options.merge(
            layout: false,
            locals: {template.to_sym => member}
          )
        )
      end.join('\n')
    else
      haml(template, options)
    end
  end
end

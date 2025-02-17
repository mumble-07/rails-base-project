class Market < ApplicationRecord
  validates :market_symbol, presence: true
  validates :curr_price, presence: true
  validates :logo_url, presence: true

  def self.list_stocks
    client = IEX::Api::Client.new(
      publishable_token: Rails.application.credentials.iex_global_api[:publishable_token],
      secret_token: Rails.application.credentials.iex_global_api[:secret_token],
      endpoint: 'https://sandbox.iexapis.com/v1'
    )

    file = File.open('app/api/stock_lists/market_symbol.txt')
    file_data = file.readlines.map(&:chomp)

    file_data.each do |data|
      create(market_symbol: data, curr_price: client.price(data), logo_url: client.logo(data))
    rescue StandardError
      nil
    end
  end
end

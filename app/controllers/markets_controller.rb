class MarketsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :handle_error
  def index
    @markets = Market.all
    @portfolios = Portfolio.all
    @user_id = params[:user_id]
    @portfolios = Portfolio.find_by(id: params[:user_id])

    # @portfolio = Market.portfolio.find_by(id: params[:user_id])
  end

  private

  def portfolio_params; end
end

class LandingPageController < ApplicationController
  def index
    @q = Item.ransack(params[:q])
    @items = @q.result(distinct: true)
  end

  def show
  end
end

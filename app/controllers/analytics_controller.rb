class AnalyticsController < ApplicationController
  def show
  end

  def borrowed_by_me
    @lendings = current_user.lendings
    @mode = "borrowed_by_me"
    render :history
  end

  def borrowed_from_me
    @lendings = Lending.where(item: current_user.items).order('created_at DESC')
    @mode = "borrowed_from_me"
    render :history
  end
end

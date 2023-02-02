class AnalyticsController < ApplicationController
  def show
    @lendings = case params[:mode]
                when "other"
                  Lending.where(item: current_user.items)
                else
                  current_user.lendings
                end
    @lendings = apply_filter(@lendings)
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

  private

  def apply_filter(lendings)
    return lendings if params[:item].blank?

    lendings.select { |lending| lending.item.name == params[:item] }
  end
end

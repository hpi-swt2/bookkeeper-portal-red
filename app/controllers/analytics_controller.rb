class AnalyticsController < ApplicationController
  def show
    @lendings = case params[:mode]
                when "other"
                  Lending.where(item: current_user.items).order('created_at DESC')
                else
                  current_user.lendings.order('created_at DESC')
                end
    @lendings = apply_filter(@lendings)
  end

  private

  def apply_filter(lendings)
    return lendings if params[:item].blank?

    lendings.select { |lending| lending.item.name == params[:item] }
  end
end

class AnalyticsController < ApplicationController
  def show
    @lendings = if params[:mode].blank? || params[:mode] == "me"
                  current_user.lendings.order('created_at DESC')
                elsif params[:mode] == "other"
                  Lending.where(item: current_user.items).order('created_at DESC')
                else
                  []
                end
    @lendings = apply_filter(@lendings)
  end

  private

  def apply_filter(lendings)
    return lendings if params[:item].blank?

    lendings.select { |lending| lending.item.name == params[:item] }
  end
end

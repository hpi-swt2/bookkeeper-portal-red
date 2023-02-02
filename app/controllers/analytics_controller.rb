class AnalyticsController < ApplicationController
  # rubocop:disable Metrics/AbcSize
  def show
    if params[:mode].blank? || params[:mode] == "me"
      @lendings = Lending.where(item: current_user.items).order('created_at DESC')
      @select_items = @lendings.map { |lending| lending.item.name }.uniq
    elsif params[:mode] == "other"
      @lendings = current_user.lendings.order('created_at DESC')
      @select_items = @lendings.map { |lending| lending.item.name }.uniq
    else
      []
    end

    @lendings = apply_filter(@lendings)
  end
  # rubocop:enable Metrics/AbcSize

  private

  def apply_filter(lendings)
    return lendings if params[:item].blank?

    lendings.select { |lending| lending.item.name == params[:item] }
  end
end

# frozen_string_literal: true

class ItemAvailabilityBadgeComponent < ViewComponent::Base
  def initialize(item:, user:)
    super()
    @item = item
    @user = user
  end

  def status_classes
    return "bg-success" if @item.not_borrowed?
    return "bg-secondary" if @item.borrowed_by?(@user)

    "bg-primary"
  end
end

# frozen_string_literal: true

class ItemAvailabilityBadgeComponent < ViewComponent::Base
  def initialize(item:, user:)
    super()
    @item = item
    @user = user
  end

  def status_text
    return "Available" if @item.lendable?
    return "Borrowed by me" if @item.borrowed_by?(@user)

    "Not Available"
  end

  def status_classes
    return "bg-success" if @item.lendable?
    return "bg-secondary" if @item.borrowed_by?(@user)

    "bg-primary"
  end
end

# frozen_string_literal: true

class ItemAvailabilityBadgeComponent < ViewComponent::Base
  def initialize(item:, user:)
    super
    @item = item
    @user = user
  end

  def status_classes
    return "bg-light" unless @user.can_borrow?(@item)
    return "bg-warning" if @item.borrowed_by?(@user)
    return "bg-secondary" if @item.reserved_by?(@user)
    return "bg-success" if @item.borrowable_by?(@user)

    "bg-primary"
  end
end

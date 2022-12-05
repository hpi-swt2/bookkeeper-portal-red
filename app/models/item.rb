# Model of the current item/asset
class Item < ApplicationRecord
  validates :name, presence: true

  enum :status, inactive: 0, active: 1

  has_many :lendings, dependent: :destroy
  has_many :reservations, dependent: :destroy
  has_many :permissions, dependent: :destroy
  has_many(
    :manager_groups,
    -> { where(permissions: { permission_type: :can_manage }) },
    through: :permissions,
    source: :group
  )
  has_many(
    :viewer_groups,
    -> { where(permissions: { permission_type: :can_view }) },
    through: :permissions,
    source: :group
  )
  has_many(
    :lender_groups,
    -> { where(permissions: { permission_type: :can_lend }) },
    through: :permissions,
    source: :group
  )

  def lendable?
    !Lending.exists?(item_id: id, completed_at: nil)
  end

  def reserved_by?(user)
    user_reservations = Reservation.where(user_id: user.id, item_id: id)
    return false if user_reservations.is_empty

    user_reservations.exists?(["DATE(starts_at) < :now AND :now <= DATE(ends_at)", { now: Time.zone.now }])
  end

  def reservable_by?(user)
    return false unless lendable?
    reservations = Reservation.where(item_id: id)
    return false if reservations.exists?(["DATE(starts_at) < :now AND :now <= DATE(ends_at)", { now: Time.zone.now }])
    return false unless user.lending_rights?(self)
    true
  end
  def borrowed_by?(user)
    Lending.exists?(user_id: user.id, item_id: id, completed_at: nil)
  end

  def status_text(user)
    return I18n.t("items.status_badge.available") if lendable?
    return I18n.t("items.status_badge.borrowed_by_me") if borrowed_by?(user)

    I18n.t("items.status_badge.not_available")
  end

  def button_text(user)
    return I18n.t("items.buttons.reserve") if reservable_by?(user)
    return I18n.t("items.buttons.borrow") if lendable?
    return I18n.t("items.buttons.return") if borrowed_by?(user)

    I18n.t("items.status_badge.not_available")
  end

  def button_path(user)
    return item_reserve_path(@item) if reservable_by?(user)
    item_update_lending_path(@item) if lendable?
  end
end

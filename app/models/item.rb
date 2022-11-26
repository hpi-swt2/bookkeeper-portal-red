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

  def is_lendable
    return !Lending.where(item_id: id, completed_at: nil).exists?
  end


  def is_reserved_by(user)
    user_reservations = Reservation.where(user_id: user.id, item_id: id)
    if user_reservations.is_empty then
      return false
    end
    return user_reservations.where("DATE(start_at) < now AND now <= DATE(ends_at)", now: Date.today).exists?
    
  end

  def is_borrowed_by(user)
    return Lending.where(user_id: user.id, item_id: id).exists?
  end
end

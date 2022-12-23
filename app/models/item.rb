# Model of the current item/asset
class Item < ApplicationRecord
  include ExportPdf

  validates :name, presence: true
  validates :max_borrowing_days, numericality: { greater_than_or_equal_to: 0 }

  enum :status, inactive: 0, active: 1
  enum :item_type, other: 0, book: 1, movie: 2, game: 3

  # hardcoded which attributes belong to which item type
  BOOK_ATTRIBUTES = %w[name isbn author release_date genre language number_of_pages publisher edition
                       description max_borrowing_days].freeze
  MOVIE_ATTRIBUTES = %w[name director release_date format genre language fsk description max_borrowing_days].freeze
  GAME_ATTRIBUTES = %w[name author illustrator publisher number_of_players playing_time language description
                       max_borrowing_days].freeze
  OTHER_ATTRIBUTES = %w[name category description max_borrowing_days].freeze

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
    :borrower_groups,
    -> { where(permissions: { permission_type: :can_borrow }) },
    through: :permissions,
    source: :group
  )

  # items can be of different types. This function returns which attributes
  # are relevant for this item depending on it's type
  def attributes
    return BOOK_ATTRIBUTES if item_type.eql? "book"
    return MOVIE_ATTRIBUTES if item_type.eql? "movie"
    return GAME_ATTRIBUTES if item_type.eql? "game"
    return OTHER_ATTRIBUTES if item_type.eql? "other"
  end

  def attribute?(attribute)
    attributes.include?(attribute)
  end

  def lendable?
    !Lending.exists?(item_id: id, completed_at: nil)
  end

  def reserved_by?(user)
    user_reservations = Reservation.where(user_id: user.id, item_id: id)
    return false if user_reservations.is_empty

    user_reservations.exists?(["DATE(start_at) < now AND now <= DATE(ends_at)", { now: Time.zone.today }])
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
    return I18n.t("items.buttons.borrow") if lendable?
    return I18n.t("items.buttons.return") if borrowed_by?(user)

    I18n.t("items.status_badge.not_available")
  end
end

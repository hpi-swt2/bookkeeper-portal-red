# Model of the current item/asset
class Item < ApplicationRecord
  include ExportPdf

  validates :name, presence: true
  validates :max_reservation_days, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 365 }
  validates :max_borrowing_days, numericality: { greater_than_or_equal_to: 0 }

  validates :number_of_pages, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true

  enum :status, inactive: 0, active: 1
  enum :item_type, other: 0, book: 1, movie: 2, game: 3

  # hardcoded which attributes belong to which item type
  COMMON_ATTRIBUTES = %w[name description max_borrowing_days max_reservation_days].freeze
  BOOK_ATTRIBUTES = %w[isbn author release_date genre language number_of_pages publisher edition].freeze
  MOVIE_ATTRIBUTES = %w[director release_date format genre language fsk].freeze
  GAME_ATTRIBUTES = %w[author illustrator publisher fsk number_of_players playing_time language].freeze
  OTHER_ATTRIBUTES = %w[category].freeze

  BOOK_IMPORTANT_ATTRIBUTES = %w[author genre language].freeze
  MOVIE_IMPORTANT_ATTRIBUTES = %w[format genre language fsk].freeze
  GAME_IMPORTANT_ATTRIBUTES = %w[number_of_players playing_time].freeze
  OTHER_IMPORTANT_ATTRIBUTES = %w[category].freeze

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
  def self.attributes(item_type)
    return COMMON_ATTRIBUTES + BOOK_ATTRIBUTES if item_type.eql? "book"
    return COMMON_ATTRIBUTES + MOVIE_ATTRIBUTES if item_type.eql? "movie"
    return COMMON_ATTRIBUTES + GAME_ATTRIBUTES if item_type.eql? "game"
    return COMMON_ATTRIBUTES + OTHER_ATTRIBUTES if item_type.eql? "other"
  end

  def attributes
    Item.attributes(item_type)
  end

  def common_attributes
    COMMON_ATTRIBUTES
  end

  def important_attributes
    return BOOK_IMPORTANT_ATTRIBUTES if item_type.eql? "book"
    return MOVIE_IMPORTANT_ATTRIBUTES if item_type.eql? "movie"
    return GAME_IMPORTANT_ATTRIBUTES if item_type.eql? "game"
    return OTHER_IMPORTANT_ATTRIBUTES if item_type.eql? "other"
  end

  def attribute?(attribute)
    attributes.include?(attribute)
  end

  def reserved?
    !current_reservation.nil?
  end

  def borrowed?
    Lending.exists?(item_id: id, completed_at: nil)
  end

  def current_reservation
    reservations = Reservation.where(item_id: id).where(["starts_at < :now AND :now <= ends_at",
                                                         { now: Time.current }])
    raise StandardError, "#{self} has multiple simultaneous reservations" if reservations.size > 1

    reservations.first
  end

  def reservable_by?(user)
    !borrowed? and !reserved? and user.can_borrow?(self)
  end

  def reserved_by?(user)
    return false if current_reservation.nil?

    current_reservation.user_id == user.id
  end

  def borrowable_by?(user)
    not_reserved_by_others = (reserved_by?(user) or !reserved?)
    !borrowed? and not_reserved_by_others and user.can_borrow?(self)
  end

  def borrowed_by?(user)
    Lending.exists?(user_id: user.id, item_id: id, completed_at: nil)
  end

  def cancel_reservation_for(user)
    return unless reserved_by?(user)

    @reservation = current_reservation
    @reservation.ends_at = Time.current
    @reservation.save
  end

  def status_text(user)
    return I18n.t("items.status_badge.no_access") unless user.can_borrow?(self)
    return I18n.t("items.status_badge.reserved_by_me") if reserved_by?(user)
    return I18n.t("items.status_badge.available") if borrowable_by?(user)
    return I18n.t("items.status_badge.borrowed_by_me") if borrowed_by?(user)

    I18n.t("items.status_badge.not_available")
  end
end

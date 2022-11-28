class Item < ApplicationRecord
    validates :name, presence: true

    has_many :lendings
    has_many :reservations
    belongs_to :group, optional: true
    enum :status, inactive: 0, active: 1
end

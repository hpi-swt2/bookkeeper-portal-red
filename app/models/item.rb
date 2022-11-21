class Item < ApplicationRecord
    validates :name, presence: true
end

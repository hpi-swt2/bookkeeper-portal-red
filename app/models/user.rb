class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :memberships, dependent: :destroy
  has_many :groups, through: :memberships
  has_many :lendings, dependent: :destroy
  has_many :reservations, dependent: :destroy

  def has_lending_rights(item)
    
    item_groups = item.lender_groups
    
    groups.each do |user_group|
      if item_groups.include? user_group then
        return true
      end
    end
    return false
 end

end

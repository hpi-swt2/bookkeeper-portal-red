# User models the current user
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :validatable,
         :omniauthable,
         omniauth_providers: [:openid_connect]

  attribute :full_name, :string, default: ""
  attribute :description, :string, default: ""

  has_many :memberships, dependent: :destroy
  has_many :groups, through: :memberships
  has_many :lendings, dependent: :destroy
  has_many :reservations, dependent: :destroy
  has_many :notifications, dependent: :destroy

  def can_borrow?(item)
    item_groups = item.borrower_groups

    groups.each do |user_group|
      return true if item_groups.include? user_group
    end
    false
  end

  def can_manage?(item)
    item_groups = item.manager_groups

    groups.each do |user_group|
      return true if item_groups.include? user_group
    end
    false
  end

  def items
    # get all items where the user is a manager of any group
    Item.joins(:manager_groups).where(groups: { id: groups })
  end

  # Handles user creation based on data returned from OIDC login process. If
  # the user already exists, returns the user.
  def self.from_omniauth(auth)
    # the field `uid` refers to the external uuid of the HPI user's account
    # rather than the the ID of the locally persisted user.
    where(provider: auth.provider, uid: auth.uid).first_or_create! do |user|
      # All information returned by OpenID Connect is passed in `auth` param
      user.full_name = auth.info.name
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
    end
  end

  def admin_in?(group)
    own_groups = groups.where(memberships: { role: :admin })
    own_groups.include? group
  end
end

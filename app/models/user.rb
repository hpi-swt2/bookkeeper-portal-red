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
  attribute :telephone_number, :string, default: ""
  has_many :memberships, dependent: :destroy
  has_many :groups, through: :memberships
  has_many :lendings, dependent: :destroy
  has_many :reservations, dependent: :destroy
  has_many :notifications, dependent: :destroy
  after_create :create_personal_group, :add_to_everyone_group
  validate :exists_personal_group?

  has_one_attached :avatar

  def can_view?(item)
    return true if can_manage?(item) || can_borrow?(item)

    item_groups = item.viewer_groups

    groups.each do |user_group|
      return true if item_groups.include? user_group
    end
    false
  end

  def can_borrow?(item)
    return true if can_manage?(item)

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

  def personal_group
    personal_groups = groups.where(groups: { tag: :personal_group })
    raise StandardError, "#{self} has multiple personal_groups" if personal_groups.size > 1
    raise StandardError, "#{self} has no personal_group" if personal_groups.empty?

    personal_groups.first
  end

  def exists_personal_group?
    personal_groups = groups.where(groups: { tag: :personal_group })
    raise StandardError, "#{self} has multiple personal_groups" if personal_groups.size > 1
    return false if personal_groups.empty?

    true
  end

  def can_return_as_owner?(item)
    !item.borrowed_by?(self) && item.borrowed? && can_manage?(item)
  end

  def items
    # get all items where the user is a manager of any group
    Item.joins(:manager_groups).where(groups: { id: groups })
  end

  def create_personal_group
    raise StandardError, "#{self} already has personal group" if exists_personal_group?

    p_group = Group.create(name: full_name, tag: :personal_group)
    p_group_membership = Membership.create(group_id: p_group.id, user_id: id, role: :member)
    memberships.push(p_group_membership)
    save
    p_group
  end

  def add_to_everyone_group
    e_group = Group.where(tag: "everyone_group").first
    # for first user
    e_group = Group.create(name: "everyone", tag: "everyone_group") if e_group.nil?
    e_group_membership = Membership.create(group_id: e_group.id, user_id: id, role: :member)
    memberships.push(e_group_membership)
    save
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

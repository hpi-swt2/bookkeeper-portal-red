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

  # Handles user creation based on data returned from OIDC login process. If
  # the user already exists, returns the user.
  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create! do |user|
      # All information returned by OpenID Connect is passed in `auth` param
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
    end
  end
end

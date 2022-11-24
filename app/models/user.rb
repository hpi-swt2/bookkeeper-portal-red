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

  has_many :memberships
  has_many :groups, through: :memberships
  has_many :lendings
  has_many :reservations

  def self.from_omniauth(auth)
    # Check if user with provider ('openid_connect') and uid is in db, otherwise create it
    where(provider: auth.provider, uid: auth.uid).first_or_create! do |user|
      # All information returned by OpenID Connect is passed in `auth` param
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
    end
  end
end

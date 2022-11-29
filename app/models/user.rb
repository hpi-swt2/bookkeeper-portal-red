class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  attribute :full_name, :string, default: ""
  attribute :description, :string, default: ""
  
  has_many :memberships, dependent: :destroy
  has_many :groups, through: :memberships
  has_many :lendings, dependent: :destroy
  has_many :reservations, dependent: :destroy
end

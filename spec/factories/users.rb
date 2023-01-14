FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    password { 'password' }
    password_confirmation { 'password' }
    full_name { "Alan Turing" }
    description { "Computer pioneer" }
    after :create do |user|
      user.create_personal_group
    end
  end
end

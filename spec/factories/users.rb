FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    password { 'password' }
    password_confirmation { 'password' }
    full_name { "Alan Turing" }
    description { "Computer pioneer" }
  end
end

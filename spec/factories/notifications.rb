FactoryBot.define do
  factory :notification do
    notification_type { "MyString" }
    message { "MyString" }
    sent { "2022-12-06 23:05:27" }
    display { false }
  end
end

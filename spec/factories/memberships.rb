FactoryBot.define do
  factory :membership do
    user { FactoryBot.create(:user) }
    group { FactoryBot.create(:group) }
    role { :member }

    trait :admin do
      role { :admin }
    end
  end
end

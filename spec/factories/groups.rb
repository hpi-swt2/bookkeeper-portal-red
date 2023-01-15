FactoryBot.define do
  factory :group do
    sequence(:name) { |n| "Group #{n}" }

    trait :verified do
      tag { :verified_group }
    end
  end
end

FactoryBot.define do
  factory :message do
    association :from_user, factory: :user
    association :to_user, factory: :user
  end
end

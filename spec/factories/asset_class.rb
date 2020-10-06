FactoryBot.define do
  factory :asset_class do
    description { Faker::Commerce.unique.department }
  end
end

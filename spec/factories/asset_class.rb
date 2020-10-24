FactoryBot.define do
  factory :sector do
    description { Faker::Commerce.unique.department }
  end
end

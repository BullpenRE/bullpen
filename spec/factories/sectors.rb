FactoryBot.define do
  factory :sector do
    sector_description { Faker::Commerce.unique.department }
  end
end

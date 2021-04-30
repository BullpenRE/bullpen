FactoryBot.define do
  factory :certification do
    description { Faker::Commerce.unique.department }
    disable { false }
    custom { false }
  end
end

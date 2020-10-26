FactoryBot.define do
  factory :skill do
    description { Faker::Company.unique.profession }
    disable { false }
  end
end

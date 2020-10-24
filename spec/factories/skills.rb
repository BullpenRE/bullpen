FactoryBot.define do
  factory :skill do
    description { Faker::Company.unique.profession }
    disabled { false }
  end
end

FactoryBot.define do
  factory :sector do
    description { Faker::Company.unique.industry }
    disabled { false }
  end
end

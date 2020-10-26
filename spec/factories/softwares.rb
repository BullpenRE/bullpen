FactoryBot.define do
  factory :software do
    description { Faker::Game.unique.title }
    disabled { false }
  end
end

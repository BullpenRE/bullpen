FactoryBot.define do
  factory :software do
    description { Faker::Game.unique.title }
    disable { false }
  end
end

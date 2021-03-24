FactoryBot.define do
  factory :certification do
    description { Faker::Commerce.unique.department }
    disable { false }
    custom { false }

    # trait :custom do
    #   description { nil }
    #   disable { true }
    #   custom { true }
    # end
  end
end

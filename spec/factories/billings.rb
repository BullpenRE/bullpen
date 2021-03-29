FactoryBot.define do
  factory :billing do
    contract
    work_done { 2.days.ago }
    hours { [1, 2, 3, 4, 5].sample }
    minutes { nil }
    description { Faker::Company.bs }

    trait :disputed do
      state { 'disputed' }
      dispute_comments { "That's too many hours!" }
    end

    trait :resolved do
      state { 'pending' }
      dispute_resolved { Time.current }
    end

    trait :paid do
      state { 'paid' }
    end
  end
end

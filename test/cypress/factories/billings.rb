FactoryBot.define do
  factory :billing do
    contract
    work_done { 2.hours.ago }
    hours { [1, 2, 3, 4, 5].sample }
    minutes { nil }
    description { Faker::Company.bs }

    # trait :disputed do
    #   state { 'disputed' }
    #   dispute_comments { "That's too many hours!" }
    # end

    # trait :resolved do
    #   state { 'pending' }
    #   dispute_resolved { Time.current }
    # end

    # trait :paid do
      state { 'paid' }
    # end
    #
    # trait :with_timesheet do
      after(:create) do |billing, _|
        billing.update(timesheet_id: create(:timesheet, starts: billing.work_done.beginning_of_week, ends: billing.work_done.end_of_week, contract: billing.contract).id)
      end
    # end

    trait :skip_validate do
          to_create {|instance| instance.save(validate: false)}
    end
 end
end

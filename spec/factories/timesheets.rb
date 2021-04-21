FactoryBot.define do
  factory :timesheet do
    contract
    starts { 1.hour.ago.beginning_of_week }
    ends { 1.hour.ago.end_of_week }

    after(:create) do |timesheet, _|
      timesheet.update(description: "#{timesheet.starts.strftime("%b %d")} to #{timesheet.ends.strftime("%b %d")}")
    end

    trait :skip_validate do
      to_create {|instance| instance.save(validate: false)}
    end
  end
end

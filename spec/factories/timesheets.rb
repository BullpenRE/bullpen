FactoryBot.define do
  factory :timesheet do
    contract
    starts { 1.week.ago.beginning_of_week }
    ends { 1.week.ago.end_of_week }

    trait :with_stripe_invoice do
      stripe_id_invoice { "in_#{Faker::Crypto.md5[0..22]}" }
      invoice_number { "abc-#{Faker::Crypto.md5[0..22]}" }
    end

    after(:create) do |timesheet, _|
      timesheet.update(description: "#{timesheet.starts.strftime("%b %d")} to #{timesheet.ends.strftime("%b %d")}")
    end
  end
end

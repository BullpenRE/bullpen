FactoryBot.define do
  factory :timesheet do
    contract
    starts { 1.hour.ago.beginning_of_week }
    ends { 1.hour.ago.end_of_week }

    trait :with_stripe_invoice do
      stripe_id_invoice { "in_#{Faker::Crypto.md5[0..22]}" }
      invoice_number { "abc-#{Faker::Crypto.md5[0..22]}" }
    end

    after(:create) do |timesheet, _|
      timesheet.update(description: "#{timesheet.starts.strftime("%b %d")} to #{timesheet.ends.strftime("%b %d")}")
    end

    trait :skip_validate do
      to_create {|instance| instance.save(validate: false)}
    end
  end
end

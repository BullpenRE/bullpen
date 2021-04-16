FactoryBot.define do
  factory :credit do
    timesheet
    applied_to { Credit.applied_tos.values.sample }
    description { Faker::Company.bs }
    amount { 150 }
  end
end

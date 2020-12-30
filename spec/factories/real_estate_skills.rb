FactoryBot.define do
  factory :real_estate_skill do
    description { Faker::Job.unique.field }
  end
end

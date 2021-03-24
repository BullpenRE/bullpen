FactoryBot.define do
  factory :job_question do
    job
    description { Faker::Hipster.sentence.chop+'?' }
  end
end

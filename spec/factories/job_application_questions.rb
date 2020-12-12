FactoryBot.define do
  factory :job_application_question do
    job_application
    job_question
    answer { Faker::Hipster.paragraph }
  end
end

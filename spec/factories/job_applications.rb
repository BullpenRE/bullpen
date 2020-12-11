FactoryBot.define do
  factory :job_application do
    job
    user
    cover_letter { Faker::Hipster.paragraphs }
    template { false }
    available_during_work_hours { [true, false].sample }
    state { [0, 1].sample }
  end
end

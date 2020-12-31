FactoryBot.define do
  factory :job_application do
    job
    association :user, :freelancer
    template { false }
    available_during_work_hours { [true, false].sample }
    liked { false }
    state { JobApplication.states.values.sample }
    trait :with_attachments do
      work_sample { Rack::Test::UploadedFile.new('spec/support/assets/sample_resume.pdf', 'application/pdf') }
      cover_letter { Rack::Test::UploadedFile.new('spec/support/assets/sample_cover_letter.html', 'text/html') }
    end
  end
end

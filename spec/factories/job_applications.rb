FactoryBot.define do
  factory :job_application do
    job
    freelancer_profile
    template { false }
    available_during_work_hours { [true, false].sample }
    liked { false }
    state { JobApplication.states.values.sample }
    trait :with_attachments do
      after(:build) do |job_application|
        job_application.work_samples.attach(io: File.open('spec/support/assets/sample_resume.pdf'),
                                            filename: 'sample_resume.pdf',
                                            content_type: 'application/pdf')
        job_application.work_samples.attach(io: File.open('spec/support/assets/sample_resume1.pdf'),
                                            filename: 'sample_resume1.pdf',
                                            content_type: 'application/pdf')
      end
      cover_letter { Rack::Test::UploadedFile.new('spec/support/assets/sample_cover_letter.html', 'text/html') }
    end
  end
end

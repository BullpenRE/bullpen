FactoryBot.define do
  factory :job_application do
    job
    association :freelancer_profile
    template { false }
    available_during_work_hours { true }
    liked { false }
    state { 'draft' }
    bid_amount { 128 }
      after(:build) do |job_application|
        job_application.work_samples.attach(io: File.open('spec/support/assets/sample_resume.pdf'),
                                            filename: 'sample_resume.pdf',
                                            content_type: 'application/pdf')
        job_application.work_samples.attach(io: File.open('spec/support/assets/sample_resume1.pdf'),
                                            filename: 'sample_resume1.pdf',
                                            content_type: 'application/pdf')
      end
      cover_letter { 'You should hire me!' }
  end
end

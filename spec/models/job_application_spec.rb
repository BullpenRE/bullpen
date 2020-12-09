require 'rails_helper'

RSpec.describe JobApplication, type: :model do
  let(:job) { FactoryBot.create(:job) }
  let(:user) { FactoryBot.create(:user) }
  let!(:job_application) { FactoryBot.create(:job_application, job: job, user: user) }

  it 'factory works' do
    expect(job_application).to be_valid
  end

  context 'Validations' do
    it 'the combination of job_id and user_id is unique' do
      duplicate = FactoryBot.create(:job_application)
      duplicate.job_id = job_application.job_id
      expect(duplicate).to be_valid
      duplicate.user_id = job_application.user_id
      expect(duplicate).to_not be_valid
    end

    it 'per_hour_bid must be either nil or greater than or equal to zero' do
      job_application.per_hour_bid = nil
      expect(job_application).to be_valid
      job_application.per_hour_bid = 0
      expect(job_application).to be_valid
      job_application.per_hour_bid = -1
      expect(job_application).to_not be_valid
    end
  end

  context 'Relationships' do
    let!(:job_question) { FactoryBot.create(:job_question, job: job) }
    let!(:job_application_question) { FactoryBot.create(:job_application_question, job_question: job_question, job_application: job_application) }

    it 'belongs to a job' do
      expect(job_application.job).to eq(job)
    end

    it 'belongs to a user' do
      expect(job_application.user).to eq(user)
    end

    it 'has many job_application_questions with dependent: :destroy' do
      expect(job_application.job_application_questions).to include(job_application_question)
      expect(JobApplicationQuestion.exists?(job_application_question.id)).to be_truthy
      job_application.destroy
      expect(JobApplicationQuestion.exists?(job_application_question.id)).to be_falsey
    end

    it 'has many job_questions through job_application_questions without dependent destroy' do
      expect(job_application.job_questions).to include(job_question)
      job_application.destroy
      expect(JobQuestion.exists?(job_question.id)).to be_truthy
    end
  end
end

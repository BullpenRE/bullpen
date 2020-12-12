require 'rails_helper'

RSpec.describe JobApplicationQuestion, type: :model do
  let(:job_question) { FactoryBot.create(:job_question) }
  let(:job_application) { FactoryBot.create(:job_application) }
  let!(:job_application_question) { FactoryBot.create(:job_application_question, job_question: job_question, job_application: job_application) }

  it 'factory works' do
    expect(job_application_question).to be_valid
  end

  context 'Validations' do
    it 'the combination of job_question_id and job_application_id must be unique' do
      duplicate = FactoryBot.create(:job_application_question)
      duplicate.job_question_id = job_application_question.job_question_id
      expect(duplicate).to be_valid
      duplicate.job_application_id = job_application_question.job_application_id
      expect(duplicate).to_not be_valid
    end
  end

  context 'Relationships' do
    it 'belongs_to a job_application' do
      expect(job_application_question.job_application).to eq(job_application)
    end
    it 'belongs_to a job_question' do
      expect(job_application_question.job_question).to eq(job_question)
    end
  end
end

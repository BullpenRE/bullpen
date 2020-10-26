require 'rails_helper'

RSpec.describe JobQuestion, type: :model do
  let(:job) { FactoryBot.create(:job) }
  let!(:job_question) { FactoryBot.create(:job_question, job: job) }

  it 'factory works' do
    expect(job_question).to be_valid
  end

  context 'Validations' do
    it 'for each job the descriptions are unique' do
      duplicate = FactoryBot.create(:job_question, description: job_question.description)
      expect(duplicate).to be_valid
      duplicate.job_id = job.id
      expect(duplicate).to_not be_valid
    end

    it 'descriptions cannot be blank' do
      expect(job_question).to be_valid
      job_question.description = ''
      expect(job_question).to_not be_valid
      job_question.description = nil
      expect(job_question).to_not be_valid
    end
  end
end

require 'rails_helper'

RSpec.describe JobSkill, type: :model do
  let(:job) { FactoryBot.create(:job) }
  let(:skill) { FactoryBot.create(:skill) }
  let!(:job_skill) { FactoryBot.create(:job_skill, job: job, skill: skill) }

  it 'factory works' do
    expect(job_skill).to be_valid
  end

  context 'Validations' do
    it 'the combination of its job_id and skill_id must be unique' do
      duplicate = FactoryBot.create(:job_skill)
      duplicate.job_id = job.id
      expect(duplicate).to be_valid
      duplicate.skill_id = skill.id
      expect(duplicate).to_not be_valid
    end
  end

  context 'Relationships' do
    it 'belongs to a job' do
      expect(job_skill.job).to eq(job)
    end

    it 'belongs to a software' do
      expect(job_skill.skill).to eq(skill)
    end
  end
end

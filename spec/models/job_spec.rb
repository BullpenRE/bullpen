require 'rails_helper'

RSpec.describe Job, type: :model do
  let!(:job) { FactoryBot.create(:job) }

  it 'factory works' do
    expect(job).to be_valid
  end

  context 'Validations' do
    it { is_expected.to validate_presence_of(:user_id) }
  end

  context 'Relationships' do
    let!(:job_sector) { FactoryBot.create(:job_sector, job: job) }
    let!(:sector) { job_sector.sector }
    let!(:job_skill) { FactoryBot.create(:job_skill, job: job) }
    let!(:skill) { job_skill.skill }
    let!(:job_question) { FactoryBot.create(:job_question, job: job) }

    it 'has many job_sectors with dependent destroy and jobs through them' do
      expect(job.job_sectors).to include(job_sector)
      expect(job.sectors).to include(sector)
      job.destroy
      expect(JobSector.exists?(job_sector.id)).to be_falsey
      expect(Sector.exists?(sector.id)).to be_truthy
    end

    it 'has many job_skills with dependent destroy and skills through them' do
      expect(job.job_skills).to include(job_skill)
      expect(job.skills).to include(skill)
      job.destroy
      expect(JobSkill.exists?(job_skill.id)).to be_falsey
      expect(Skill.exists?(skill.id)).to be_truthy
    end

    it 'has many job_questions with dependent destroy' do
      expect(job.job_questions).to include(job_question)
      job.destroy
      expect(JobQuestion.exists?(job_question.id)).to be_falsey
    end
  end
end

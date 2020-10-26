require 'rails_helper'

RSpec.describe Skill, type: :model do
  let!(:skill) { FactoryBot.create(:skill) }

  it 'factory works' do
    expect(skill).to be_valid
  end

  context 'Validations' do
    it 'description is unique' do
      new_skill = FactoryBot.create(:skill)
      expect(new_skill).to be_valid
      new_skill.description = skill.description
      expect(new_skill).to_not be_valid
    end
  end

  context 'Relationships' do
    let!(:job_skill) { FactoryBot.create(:job_skill, skill: skill) }
    let!(:job) { job_skill.job }

    it 'has many job_skills' do
      expect(skill.job_skills).to include(job_skill)
    end

    it 'has many jobs through job_skills' do
      expect(skill.jobs).to include(job)
    end

    it 'job_skills are dependent destroyed, jobs are not' do
      skill.destroy
      expect(JobSkill.exists?(job_skill.id)).to be_falsey
      expect(Job.exists?(job.id)).to be_truthy
    end
  end
end

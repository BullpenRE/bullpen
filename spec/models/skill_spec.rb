require 'rails_helper'

RSpec.describe Skill, type: :model do
  let!(:skill) { FactoryBot.create(:skill) }

  it 'factory works' do
    expect(skill).to be_valid
  end

  context 'Validations' do
    it 'description is unique and present' do
      new_skill = FactoryBot.create(:skill)
      expect(new_skill).to be_valid
      new_skill.description = skill.description
      expect(new_skill).to_not be_valid
      skill.description = ''
      expect(skill).to_not be_valid
    end
  end

  context 'Relationships' do
    let!(:job_skill) { FactoryBot.create(:job_skill, skill: skill) }
    let!(:job) { job_skill.job }

    it 'has many job_skills dependent destroy' do
      expect(skill.job_skills).to include(job_skill)
      skill.destroy
      expect(JobSkill.exists?(job_skill.id)).to be_falsey
      expect(Job.exists?(job.id)).to be_truthy
    end

    it 'has many jobs through job_skills' do
      expect(skill.jobs).to include(job)
    end
  end

  context 'Scopes' do
    describe 'default_scope' do
      it 'orders by description alphabetically' do
        ('A'..'Z').to_a.each { |letter| FactoryBot.create(:skill, description: "#{letter} Skill") }
        expect(Skill.all.pluck(:description)).to match(Skill.order(description: :asc).pluck(:description))
      end
    end

    it '.enabled' do
      disabled_skill = FactoryBot.create(:skill, disable: true)
      expect(skill.disable).to be_falsey
      expect(Skill.enabled).to include(skill)
      expect(Skill.enabled).to_not include(disabled_skill)
    end
  end
end

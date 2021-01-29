# frozen_string_literal: true

class Contract < ApplicationRecord
  belongs_to :freelancer_profile
  belongs_to :employer_profile
  belongs_to :job, optional: true
  has_rich_text :job_description

  scope :visible, -> { where.not(state: 'declined').where.not(state: 'withdrawn') }

  enum state: { 'pending': 0, 'declined': 1, 'withdrawn': 2, 'active': 3, 'closed': 4, 'deleted': 5 }
  enum contract_type: Job.contract_types

  validate :between_different_parties

  after_create :inherit_job_attributes, if: -> { job_id }

  private

  def between_different_parties
    return unless freelancer_profile.user_id == employer_profile.user_id

    errors.add(:to_user_id, "can't make a contract with yourself")
  end

  def inherit_job_attributes
    return unless job.present?

    self.title = job.title if title.blank?
    self.job_description = job.short_description unless job_description.present?
    self.contract_type = job.contract_type unless contract_type
    save
  end
end

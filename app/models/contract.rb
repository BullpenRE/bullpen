class Contract < ApplicationRecord
  belongs_to :from_user, class_name: 'User', foreign_key: :from_user_id
  belongs_to :to_user, class_name: 'User', foreign_key: :to_user_id
  belongs_to :job, optional: true

  scope :visible, -> { where.not(state: 'declined').where.not(state: 'withdrawn') }

  enum state: { 'pending': 0, 'declined': 1, 'withdrawn': 2, 'active': 3, 'closed': 4 }
  enum contract_type: Job.contract_types

  validate :between_different_parties

  after_create :inherit_job_attributes, if: -> { job_id }

  private

  def between_different_parties
    errors.add(:to_user_id, "can't make a contract with yourself") if to_user_id == from_user_id
  end

  def inherit_job_attributes
    return unless job.present?

    self.title = job.title unless title
    self.short_description = job.short_description unless short_description
    self.contract_type = job.contract_type unless contract_type
    save
  end
end

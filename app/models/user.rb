# frozen_string_literal: true

class User < ApplicationRecord
  scope :confirmed, -> { where.not(confirmed_at: nil) }
  scope :no_freelancer_data, -> { left_joins(:freelancer_profile).where(freelancer_profiles: { user_id: nil }) }
  scope :no_employer_data, -> { left_joins(:employer_profile).where(employer_profiles: { user_id: nil }) }

  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable
  validates :first_name, presence: true
  validates :last_name, presence: true

  has_one :freelancer_profile, dependent: :destroy
  has_many :jobs, dependent: :destroy
  has_many :freelancer_real_estate_skills, through: :freelancer_profile
  has_many :freelancer_sectors, through: :freelancer_profile

  has_one :employer_profile, dependent: :destroy

  def self.ransackable_scopes(_auth_object = nil)
    [:confirmed]
  end

  def full_name
    "#{first_name} #{last_name}"
  end
end

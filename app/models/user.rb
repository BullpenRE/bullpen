# frozen_string_literal: true

class User < ApplicationRecord
  scope :confirmed, -> { where.not(confirmed_at: nil) }
  scope :no_freelancer_data, -> { left_joins(:freelancer_profile).where(freelancer_profiles: { user_id: nil }) }
  scope :no_employer_data, -> { left_joins(:employer_profile).where(employer_profiles: { user_id: nil }) }
  scope :employers, -> { joins(:employer_profile) }
  scope :freelancers, -> { joins(:freelancer_profile) }

  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :confirmable,
         :omniauthable, omniauth_providers: %i[google]
  validates :first_name, presence: true
  validates :last_name, presence: true

  has_one :freelancer_profile, dependent: :destroy
  has_many :jobs, dependent: :destroy
  has_many :freelancer_real_estate_skills, through: :freelancer_profile
  has_many :freelancer_sectors, through: :freelancer_profile
  has_one :employer_profile, dependent: :destroy
  has_many :employer_sectors, through: :employer_profile
  has_many :job_applications, dependent: :destroy
  has_many :sent_messages, class_name: 'Message', foreign_key: :from_user_id
  has_many :received_messages, class_name: 'Message', foreign_key: :to_user_id

  belongs_to :signup_promo, optional: true

  enum role: { freelancer: 0, employer: 1 }

  geocoded_by :location
  after_validation :geocode, if: ->(obj) { obj.location.present? && obj.location_changed? }

  def self.ransackable_scopes(_auth_object = nil)
    [:confirmed]
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def employer?
    role == 'employer'
  end

  def freelancer?
    role == 'freelancer'
  end

  def posted_jobs
    return nil unless employer? && employer_profile

    employer_profile.jobs.posted
  end

  def avatar
    return nil unless profile&.avatar&.attached?

    profile&.avatar
  end

  def bullpen_personnel?
    email.match?('@bullpenre.com') && confirmed_at.present?
  end

  private

  def profile
    @profile ||= employer? ? employer_profile : freelancer_profile
  end
end

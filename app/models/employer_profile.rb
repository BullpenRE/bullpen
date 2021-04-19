# frozen_string_literal: true

class EmployerProfile < ApplicationRecord
  belongs_to :user
  has_many :employer_sectors, dependent: :destroy
  has_many :sectors, through: :employer_sectors
  has_many :interview_requests, dependent: :destroy
  has_many :contracts, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many :jobs, dependent: :destroy
  has_many :payment_accounts, dependent: :destroy
  has_one_attached :avatar
  validates :credit_balance, allow_nil: true, numericality: { greater_than_or_equal_to: 0 }

  AVAILABLE_CARD_YEARS = (Time.current.year..15.years.from_now.year).freeze

  after_commit :retrieve_customer_id, on: :create

  accepts_nested_attributes_for :user,
                                allow_destroy: true,
                                update_only: true,
                                reject_if: :all_blank

  scope :users, -> { joins(:user) }
  scope :user_enabled, -> { joins(:user).where(user: { disable: false }) }

  enum employee_count: { '1-10': 0, '11-50': 1, '51-100': 2, '101+': 3 }
  enum category: {
    'Brokerage': 0,
    'Capital Markets': 1,
    'Corporate': 2,
    'Development': 3,
    'Private Equity': 4,
    'Other': 5
  }

  def email
    @email ||= user.email
  end

  def full_name
    @full_name ||= user.full_name
  end

  def default_message_for_interview(freelancer_profile)
    "Hi #{freelancer_profile.user.first_name},<br>
    I found your profile on Bullpen and think you’d be a great fit for a project
    I’m working on. Are you open to connecting on a call?<br>
    - #{user.first_name}"
  end

  def disabled
    @disabled ||= user.disable
  end

  private

  def retrieve_customer_id
    Stripe::RetrieveCustomerIdWorker.perform_async(user.id)
  end
end

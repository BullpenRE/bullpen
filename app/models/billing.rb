# frozen_string_literal: true

class Billing < ApplicationRecord
  belongs_to :contract
  belongs_to :timesheet, optional: true
  enum state: { 'pending': 0, 'disputed': 1, 'paid': 2 }
  default_scope { order(work_done: :desc, created_at: :desc) }
  scope :resolved, -> { where(state: 'pending').where.not(dispute_resolved: nil) }
  scope :not_paid, -> { where.not(state: 'paid') }

  validates :hours, allow_nil: true, numericality: { greater_than_or_equal_to: 0 }
  validates :minutes, allow_nil: true, numericality: { greater_than_or_equal_to: 0, less_than: 60 }
  validate :must_have_some_time_entered, :same_contract_as_timesheet
  validate :work_done_in_current_week, on: :create, unless: -> { skip_work_done_in_current_week_validation.present? }
  validate :work_done_in_timesheet, on: :update, unless: -> { skip_work_done_in_timesheet_validation.present? }

  after_create :attach_to_relevant_timesheet
  attr_accessor :skip_work_done_in_current_week_validation, :skip_work_done_in_timesheet_validation

  def multiplier
    hours.to_i + (minutes.to_i / 60.0)
  end

  def attach_to_relevant_timesheet
    return if timesheet.present?

    update(timesheet: relevant_timesheet)
  end

  private

  def work_done_in_current_week
    return unless work_done < Date.current.beginning_of_week - 1.day

    errors.add(:work_done, 'date must be greater than start of week')
  end

  def work_done_in_timesheet
    return if work_done >= timesheet.starts && work_done <= timesheet.ends

    errors.add(:work_done, 'date must be in current timesheet')
  end

  def must_have_some_time_entered
    errors.add(:hours, 'no time was entered for the billing entry') unless multiplier > 0.0
  end

  def same_contract_as_timesheet
    return unless timesheet_id

    errors.add(:contract_id, 'contract is different than its timesheet') if timesheet.contract_id != contract_id
  end

  def relevant_timesheet
    @relevant_timesheet ||=
      contract.timesheets.find_by(starts: ..work_done, ends: work_done..) ||
      create_new_timesheet!
  end

  def create_new_timesheet!
    contract.timesheets.new(
      starts: new_timesheet_starts,
      ends: new_timesheet_ends,
      description: "#{new_timesheet_starts.strftime('%b %d')} to #{new_timesheet_ends.strftime('%b %d')}"
    )
  end

  def new_timesheet_starts
    work_done.monday? ? work_done : work_done.prev_occurring(:monday)
  end

  def new_timesheet_ends
    work_done.sunday? ? work_done : work_done.next_occurring(:sunday)
  end
end

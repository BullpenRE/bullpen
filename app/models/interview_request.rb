# frozen_string_literal: true

class InterviewRequest < ApplicationRecord
  belongs_to :employer_profile
  belongs_to :freelancer_profile

  enum state: { 'pending': 0, 'accepted': 1, 'withdrawn': 2 }

  validates :employer_profile_id, uniqueness: { scope: :freelancer_profile_id }

  def message_paragraphs
    message.split("\n").reject(&:blank?)
  end
end

# frozen_string_literal: true

class PaymentAccount < ApplicationRecord
  belongs_to :employer_profile
  has_many :contracts, dependent: :nullify
  enum stripe_object: { card: 0, bank_account: 1 }
  validates :last_four, length: { is: 4 }, allow_blank: true, allow_nil: true
  after_save :set_other_defaults_false, if: :is_default?

  default_scope { order('is_default DESC, stripe_object ASC, created_at DESC') }

  def institution
    stripe_object == 'card' ? card_brand : bank_name
  end

  def status
    stripe_object == 'card' ? card_cvc_check : bank_status
  end

  def expired?
    return false if card_expires.blank?

    card_expires.past?
  end

  def short_description
    "#{brand} ending in #{last_four}#{' (default)' if is_default?}"
  end

  def expiration_description
    return unless card_expires.present?

    "Expires #{card_expires.strftime('%m/%y')}"
  end

  private

  def brand
    stripe_object == 'card' ? "#{card_brand} card" : 'Bank account'
  end

  def set_other_defaults_false
    PaymentAccount.where(employer_profile_id: employer_profile_id).where.not(id: id).update_all(is_default: false)
  end
end

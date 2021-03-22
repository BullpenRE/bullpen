# frozen_string_literal: true

class PaymentAccount < ApplicationRecord
  belongs_to :employer_profile
  has_many :contracts, dependent: :nullify
  enum stripe_object: { card: 0, bank_account: 1 }
  validates :last_four, length: { is: 4 }, allow_blank: true, allow_nil: true
  after_save :set_other_defaults_false, if: :is_default?

  scope :filter_and_sort, lambda { |employer_profile_id|
    where(employer_profile_id: employer_profile_id)
      .order('is_default DESC NULLS LAST')
      .order('stripe_object ASC')
      .order('created_at DESC')
  }

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
    exp_date = strftime('%m/%y')
    "Expires #{exp_date}"
  end

  private

  def brand
    stripe_object == 'card' ? "#{card_brand} card" : 'Bank account'
  end

  def set_other_defaults_false
    PaymentAccount.where(employer_profile_id: employer_profile_id).where.not(id: id).update_all(is_default: false)
  end
end

class Message < ApplicationRecord
  belongs_to :from_user, class_name: 'User', foreign_key: :from_user_id
  belongs_to :to_user, class_name: 'User', foreign_key: :to_user_id
  has_rich_text :description

  validate :sent_to_different_person

  private

  def sent_to_different_person
    errors.add(:to_user_id, "can't send a message to yourself") if to_user_id == from_user_id
  end
end

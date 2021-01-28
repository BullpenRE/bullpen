class Contract < ApplicationRecord
  belongs_to :from_user, class_name: 'User', foreign_key: :from_user_id
  belongs_to :to_user, class_name: 'User', foreign_key: :to_user_id
  belongs_to :job, optional: true

  enum state: { 'pending': 0, 'declined': 1, 'withdrawn': 2, 'active': 3, 'closed': 4 }
  enum contract_type: Job.contract_types
end

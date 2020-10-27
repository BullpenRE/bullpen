class SetUsersRole < ActiveRecord::Migration[6.0]
  def up
    User.find_each do |user|
      if user.is_employer == true
        user.update(role: :employer)
      else
        user.update(role: :freelancer)
      end
    end
  end
end

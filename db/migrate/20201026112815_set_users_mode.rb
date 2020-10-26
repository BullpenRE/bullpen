class SetUsersMode < ActiveRecord::Migration[6.0]
  def up
    User.find_each do |user|
      if user.is_employer == true
        user.update(mode: :employer)
      else
        user.update(mode: :freelancer)
      end
    end
  end
end

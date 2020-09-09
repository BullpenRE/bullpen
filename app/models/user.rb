class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :confirmable, :trackable
end

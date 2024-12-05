# app/models/user.rb
class User < ApplicationRecord
  enum role: { author: 0, editor: 1, admin: 2 }

  # Devise modules
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable
  has_many :posts, dependent: :destroy
end

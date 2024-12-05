# app/models/post_history.rb
class PostHistory < ApplicationRecord
  belongs_to :post
  belongs_to :user

  enum action: { created: 0, edited: 1, approved: 2, rejected: 3, pending_revision:4, published: 5 }
end

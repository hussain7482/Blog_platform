class Post < ApplicationRecord
  belongs_to :user
  has_one_attached :image
  has_many :post_histories, dependent: :destroy

  enum status: { draft: 0, pending_approval: 1, approved: 2, rejected: 3, pending_revision: 4, published: 5 }

  validates :title, presence: true
  validates :content, presence: true
  validates :image, presence: true

  after_initialize :set_default_status, if: :new_record?

  def create_history(action, user, comment = nil)
    post_histories.create(action: action, user: user, comment: comment)
  end

  private

  def set_default_status
    self.status ||= 'draft'
  end
end

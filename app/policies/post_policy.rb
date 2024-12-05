# app/policies/post_policy.rb
class PostPolicy < ApplicationPolicy
  def create?
    user.author? || user.editor? || user.admin?
  end

  def update?
    user.author? && record.user == user
  end

  def approve?
    user.editor? && record.status == "pending_approval"
  end

  def reject?
    user.editor? && record.status == "pending_approval"
  end

  def publish?
    user.admin? && record.status == "approved"
  end
end

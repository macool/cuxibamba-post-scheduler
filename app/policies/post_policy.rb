class PostPolicy < ApplicationPolicy
  MAX_POSTS_ALLOWED_FOR_STANDARD_USER = 10

  def new?
    create?
  end

  def create?
    user.plan.premium? || (
      !already_scheduled_for_date? && posts_count_valid?
    )
  end

  def destroy?
    !record.reposted? && owned_by_user?
  end

  def load_errors_in_post!
    if already_scheduled_for_date?
      record.errors.add(:share_at, :already_scheduled_for_date, date: record.share_at.to_date)
    end
  end

  private

  def owned_by_user?
    record.user == user
  end

  def already_scheduled_for_date?
    record.share_at.present? && user.posts.for_date(record.share_at).exists?
  end

  def posts_count_valid?
    user.posts.unpublished.count <= MAX_POSTS_ALLOWED_FOR_STANDARD_USER
  end
end

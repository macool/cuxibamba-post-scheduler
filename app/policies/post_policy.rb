class PostPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.is_admin?
        scope
      else
        scope.where(user_id: user.id)
      end
    end

    def latest_posts
      if user.is_admin?
        scope.published
      else
        scope.published.highlighted
      end
    end
  end

  MAX_POSTS_ALLOWED_FOR_STANDARD_USER = 10

  def new?
    create?
  end

  def create?
    user.plan.premium? || (
      !already_scheduled_for_date? && posts_count_valid?
    )
  end

  def edit?
    (owned_by_user? && !record.reposted?) || user.is_admin?
  end

  def update?
    edit?
  end

  def destroy?
    (owned_by_user? && !record.reposted?) || user.is_admin?
  end

  def highlight?
    user.is_admin?
  end

  def load_errors_in_post!
    if already_scheduled_for_date?
      record.errors.add(:share_at, :already_scheduled_for_date, date: record.share_at.to_date)
    end
  end

  def permitted_attributes
    base = [
      :share_at,
      :content,
      :external_provider_id,
      :target_link,
      :banner,
      :banner_cache,
      :remove_banner,
      :format_md
    ]
    if user.plan.premium?
      base << :auto_follow_link
    end
    base
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

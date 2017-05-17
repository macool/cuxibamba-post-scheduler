class PostPolicy < ApplicationPolicy
  MAX_POSTS_ALLOWED_FOR_STANDARD_USER = 2

  def new?
    create?
  end

  def create?
    user.plan.premium? || user_posts_count_valid?
  end

  private

  def user_posts_count_valid?
    user.posts.unpublished.count <= MAX_POSTS_ALLOWED_FOR_STANDARD_USER
  end
end

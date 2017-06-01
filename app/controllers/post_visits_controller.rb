class PostVisitsController < ApplicationController
  def show
    @user = get_user
    @post = @user.posts.find params[:post_id]

    add_breadcrumbs!
    log_visit!

    @post = @post.decorate

    if @user.plan.premium? && @post.target_link.present? && @post.auto_follow_link
      redirect_to @post.target_link
    end
  end

  private

  def add_breadcrumbs!
    if current_user
      semantic_breadcrumb :posts, :posts_path
      semantic_breadcrumb @post, :posts_path
    end
  end

  def get_user
    ##
    # attempt to get by slug
    return User.find_by slug: params[:user_id]
  rescue Mongoid::Errors::DocumentNotFound
    ##
    # or fallback to id
    User.find params[:user_id]
  end

  def log_visit!
    if session[:visited_posts] && session[:visited_posts].include?(@post.id.to_s)
      return false
    end

    if current_user && @post.user == current_user
      return false
    end

    session[:visited_posts] ||= []
    session[:visited_posts] << @post.id.to_s

    PostVisit.create!(
      post: @post,
      user: current_user,
      ip: request.ip,
      referer: request.referer,
      user_agent: request.user_agent
    )
  end
end

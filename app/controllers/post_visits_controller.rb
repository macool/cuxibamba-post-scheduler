class PostVisitsController < ApplicationController
  def show
    @user = User.find params[:user_id]
    @post = @user.posts.find params[:post_id]

    log_visit!

    if @user.plan.premium? && @post.target_link.present?
      redirect_to @post.target_link
    end
  end

  private

  def log_visit!
    if session[:visited_posts] && session[:visited_posts].include?(@post.id.to_s)
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

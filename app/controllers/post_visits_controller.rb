class PostVisitsController < ApplicationController
  def show
    @user = User.find params[:user_id]
    @post = @user.posts.find params[:post_id]

    log_visit!

    if @user.plan.premium? && @post.target_link.present?
      redirect_to @post.target_link
    else
      fail "todo!"
    end
  end

  private

  def log_visit!
    PostVisit.create!(
      post: @post,
      user: current_user,
      ip: request.ip,
      referer: request.referer,
      user_agent: request.user_agent
    )
  end
end

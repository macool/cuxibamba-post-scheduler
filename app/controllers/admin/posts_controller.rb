class Admin::PostsController < ::ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_admin!
  before_action :find_post

  def toggle_highlight
    @post.highlight = !@post.highlight
    @post.save validate: false
    redirect_to :back
  end

  private

  def find_post
    @post = Post.find params[:id]
  end

  def authenticate_admin!
    unless current_user.is_admin?
      redirect_to root_path and return false
    end
  end
end

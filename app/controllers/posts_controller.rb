class PostsController < ApplicationController
  before_action :authenticate_user!,
                only: [:new, :create]
  def index
    @posts = Post.all
  end

  def new
    @post = Post.new
    authorize @post
  end

  def create
    @post = current_user.posts.new(post_params)
    authorize @post
    if @post.save
      flash[:success] = t("ui.post.created")
      redirect_to action: :index
    else
      flash[:error] = t("ui.post.cant_create", reason: @post.errors.full_messages.join(", "))
      render :new
    end
  end

  private

  def post_params
    params.require(:post).permit(:share_at, :content)
  end
end

class PostsController < ApplicationController
  before_action :authenticate_user!,
                only: [:index, :new, :create]

  semantic_breadcrumb :index, :posts_path

  def index
    @future_posts = Post.unpublished.fifo.from_user(current_user).decorate
    @latest_posts = Post.published.last_published.decorate
  end

  def new
    @post = Post.new
    authorize @post
    semantic_breadcrumb :new, :new_post_path
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

  def mapped_external_providers
    Wuxi::ExternalProvider.all.map do |external_provider|
      [ external_provider.place, external_provider.id ]
    end
  end
  helper_method :mapped_external_providers

  def post_params
    params.require(:post).permit(
      :share_at,
      :content,
      :external_provider_id,
      :target_link
    )
  end
end

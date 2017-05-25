class PostsController < ApplicationController
  before_action :authenticate_user!,
                only: [:index, :new, :create]

  semantic_breadcrumb :index, :posts_path

  def index
    @future_posts = Post.unpublished.fifo.from_user(current_user).decorate
    @latest_posts = Post.published.last_published.decorate
  end

  def new
    semantic_breadcrumb :new, :new_post_path
    @post = Post.new
    unless post_policy.new?
      flash[:error] = t(
        "ui.post.not_allowed",
        count: post_policy.class::MAX_POSTS_ALLOWED_FOR_STANDARD_USER
      )
      return redirect_to action: :index
    end
  end

  def create
    @post = current_user.posts.new(post_params)
    if post_policy.create? && @post.save
      flash[:success] = t("ui.post.created", date: @post.share_at.to_s)
      redirect_to action: :index
    else
      post_policy.load_errors_in_post!
      flash[:error] = t(
        "ui.post.cant_create",
        reason: @post.errors.messages.values.flatten.join(", ")
      )
      render :new
    end
  end

  private

  def post_policy
    @post_policy ||= policy(@post)
  end

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

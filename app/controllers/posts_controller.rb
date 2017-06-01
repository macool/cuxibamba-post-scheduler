class PostsController < ApplicationController
  before_action :authenticate_user!,
                only: [:index, :new, :create]
  before_action :find_post,
                only: [:edit, :update, :destroy]

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

  def edit
    authorize @post
    semantic_breadcrumb @post, @post.decorate.sharing_url
    semantic_breadcrumb :edit, :edit_post_path
  end

  def create
    @post = current_user.posts.new(
      policy_scope(Post).permitted_attributes
    )
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

  def update
    authorize @post
    if @post.update(permitted_attributes(@post))
      flash[:success] = t("ui.post.updated")
      redirect_to @post.decorate.sharing_url
    else
      render :edit
    end
  end

  def destroy
    authorize @post
    @post.destroy
    flash[:success] = t("ui.post.destroyed")
    redirect_to action: :index
  end

  private

  def find_post
    @post = policy_scope(Post).find(params[:id])
  end

  def post_policy
    @post_policy ||= policy(@post)
  end

  def mapped_external_providers
    Wuxi::ExternalProvider.active_for_api.map do |external_provider|
      [ external_provider.place, external_provider.id.to_s ]
    end
  end
  helper_method :mapped_external_providers
end

class PostsController < ApplicationController
  before_action :authenticate_user!,
                only: [:index]
  before_action :find_post,
                only: [:edit, :update, :destroy]

  semantic_breadcrumb :index, :posts_path

  def index
    @future_posts = Post.unpublished.fifo.from_user(current_user).decorate
    @latest_posts = get_latest_posts
  end

  def new
    semantic_breadcrumb :new, :new_post_path
    @post = Post.new share_at: Date.tomorrow
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
    if current_user.present?
      create_as_user
    else
      build_as_guest
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

  def preview_md_content
    post = Post.new(format_md: true, content: params[:value])
    content = post.decorate.parsed_content
    render text: content
  end

  private

  def build_as_guest
    @post = Post.new(
      params.require(:post).permit(policy(Post).permitted_attributes)
    )
    if @post.save
      semantic_breadcrumb :build_as_guest
      persist_to_session!
      flash[:notice] = t("ui.post.created_as_guest", date: @post.share_at.to_s)
      render :build_as_guest
    else
      cant_create_post
    end
  end

  def persist_to_session!
    session[:posted_as_guest] ||= []
    session[:posted_as_guest] << @post.id.to_s
  end

  def create_as_user
    @post = current_user.posts.new(
      params.require(:post).permit(policy(Post).permitted_attributes)
    )
    if post_policy.create? && @post.save
      flash[:success] = t("ui.post.created", date: @post.share_at.to_s)
      redirect_to action: :index
    else
      post_policy.load_errors_in_post!
      cant_create_post
    end
  end

  def cant_create_post
    flash[:error] = t(
      "ui.post.cant_create",
      reason: @post.errors.messages.values.flatten.join(", ")
    )
    render :new
  end

  def get_latest_posts
    scope = PostPolicy::Scope.new(current_user, Post)
    scope.latest_posts.last_published.decorate
  end

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

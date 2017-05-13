class Api::PostsController < Api::BaseController
  def index
    posts = index_scope.decorate.map(&:json_for_api)
    render json: { posts: posts }
  end

  def show
    post = show_scope.find(params[:id])
    render json: { post: post.decorate.json_for_api }
  end

  def update
    post = update_scope.find params[:id]
    post.update!(post_params)
    render json: { post: post.decorate.json_for_api }
  end

  private

  def post_params
    params.permit(Post::API_PERMITTED_PARAMS)
  end

  def show_scope
    Post.unpublished
  end

  def update_scope
    Post.unpublished
        .for_external_provider(
          params[:post][:external_provider_id]
        )
  end

  def index_scope
    Post.fifo
        .unpublished
        .repost_today
        .for_external_provider(params[:external_provider_id])
  end
end

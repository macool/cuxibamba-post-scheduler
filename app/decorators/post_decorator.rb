class PostDecorator < ApplicationDecorator
  decorates_association :user

  def decorated_external_provider
    @decorated_external_provider ||= ::Wuxi::ExternalProviderDecorator.new(external_provider)
  end

  def json_for_api
    {
      id: object.id.to_s,
      created_at: object.created_at,
      target_link: object.target_link,
      share_at: object.share_at.to_date,
      external_provider_id: object.external_provider_id,
      repost_content: repost_content,
      tweet_id: object.tweet_id,
      published_at: object.published_at
    }
  end

  def repost_content
    # TODO revise
    content = object.content
    content += " #{sharing_url}"
    if user.plan.standard?
      content += "\nvía @#{user.nickname}"
    end
    content
  end

  def repost_url
    base = decorated_external_provider.external_link
    "#{base}/status/#{tweet_id}"
  end

  def sharing_url
    host = Rails.application.secrets.app_url
    host + h.consume_post_visit_path(
      post_id: id,
      user_id: user.id
    )
  end

  def visits_count
    object.post_visits.count
  end

  private

  def external_provider
    if external_provider_id.present?
      ::Wuxi::ExternalProvider.find(external_provider_id)
    end
  end
end

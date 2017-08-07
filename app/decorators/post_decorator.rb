class PostDecorator < ApplicationDecorator
  decorates_association :user

  ##
  # see t.co length
  # https://dev.twitter.com/basics/tco#will-t-co-wrapped-links-always-be-the-same-length
  SHARING_URL_LENGTH = 25
  TWITTER_MAX_LENGTH = 140

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
      published_at: object.published_at,
      banner_url: object.banner_url
    }
  end

  def repost_content
    max_length = TWITTER_MAX_LENGTH - SHARING_URL_LENGTH - content_footer.length
    content = stripped_content(max_length: max_length)
    content += "\n#{sharing_url}"
    content += content_footer
    content
  end

  def content_footer
    if user.plan.standard?
      "\nvía @#{user.nickname}"
    else
      # no footer (leave for more user chars)
      ""
    end
  end

  def repost_url
    base = decorated_external_provider.external_link
    "#{base}/status/#{tweet_id}"
  end

  def sharing_url
    host = Rails.application.secrets.app_url
    host + h.consume_post_visit_path(
      post_id: id,
      user_id: user.slug
    )
  end

  def visits_count
    object.post_visits.count
  end

  def parsed_content
    if object.format_md?
      h.auto_link(
        markdown(content).chomp,
        html: { target: '_blank' }
      )
    else
      content
    end
  end

  def stripped_content(max_length: TWITTER_MAX_LENGTH)
    h.truncate(
      h.strip_tags(parsed_content),
      length: max_length,
      separator: ' ',
      omission: '..'
    )
  end

  def target_link_host
    uri = URI.parse(target_link)
    uri.host.to_s + uri.path.to_s
  rescue URI::InvalidURIError
    target_link
  end

  def target_link_with_scheme
    uri = URI.parse(target_link)
    if uri.scheme.blank?
      scheme = 'http://'
    end
    scheme.to_s + uri.to_s
  rescue URI::InvalidURIError
    target_link
  end

  private

  def markdown(text)
    Kramdown::Document.new(text).to_html
  end

  def external_provider
    if external_provider_id.present?
      ::Wuxi::ExternalProvider.find(external_provider_id)
    end
  end
end

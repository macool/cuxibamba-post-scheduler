class TwitterService
  def initialize(content:, via:)
    @content = content
    @via = via
  end

  def speak!
    twitter_client.update!("#{@content} (vía @#{@via})")
  end

  private

  def twitter_client
    Twitter::REST::Client.new do |config|
      config.consumer_key = Rails.application.secrets.twitter_secret_api_key
      config.consumer_secret = Rails.application.secrets.twitter_secret_api_secret
      config.access_token = Rails.application.secrets.twitter_secret_access_token
      config.access_token_secret = Rails.application.secrets.twitter_secret_access_secret
    end
  end
end

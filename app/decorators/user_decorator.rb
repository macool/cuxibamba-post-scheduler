class UserDecorator < ApplicationDecorator
  def image
    object.info["image"]
  end

  def name
    object.info["name"]
  end

  def nickname
    object.info["nickname"]
  end

  def twitter_profile_link(&block)
    twitter_uri = "https://twitter.com/#{nickname}"
    h.link_to twitter_uri,
              class: "twitter-profile-link",
              target: "_blank" do
      yield
    end
  end
end

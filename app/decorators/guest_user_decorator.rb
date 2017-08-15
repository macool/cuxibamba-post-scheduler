class GuestUserDecorator < ApplicationDecorator
  def image
    "http://0.gravatar.com/avatar/ad516503a11cd5ca435acc9bb6523536?s=256"
  end

  def name
    h.t "guest_user.name"
  end

  def twitter_profile_link(&block)
    h.content_tag :span, class: "twitter-profile-link" do
      yield
    end
  end
end

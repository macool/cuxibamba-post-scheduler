class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def twitter
    @user = User.from_omniauth(request.env["omniauth.auth"])
    @user.cache_image!
    persist_guest_posts!
    flash[:success] = I18n.t(
      "ui.welcome",
      name: "@#{@user.info["name"]}"
    )
    sign_in_and_redirect @user, event: :authentication
  end

  def failure
    flash[:error] = I18n.t("ui.error.cant_authorize")
    redirect_to root_path
  end

  private

  def persist_guest_posts!
    session[:posted_as_guest].each do |post_id|
      Post.not_guest.find(post_id).update! user_id: @user.id
    end
    session[:posted_as_guest] = nil
  end
end

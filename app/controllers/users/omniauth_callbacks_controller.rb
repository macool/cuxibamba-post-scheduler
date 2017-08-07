class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def twitter
    @user = User.from_omniauth(request.env["omniauth.auth"])
    @user.cache_image!
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
end

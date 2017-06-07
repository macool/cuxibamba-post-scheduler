class HomeController < ApplicationController
  before_action :redirect_to_posts_if_current_user

  def welcome
  end

  def howto
  end

  private

  def redirect_to_posts_if_current_user
    if current_user
      redirect_to(posts_path)
    end
  end
end

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
end

class ApplicationController < ActionController::Base
  include Pundit
  protect_from_forgery with: :exception
  delegate :t, to: :I18n
end

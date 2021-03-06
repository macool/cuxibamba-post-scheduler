class Api::BaseController < ApplicationController
  skip_before_action :verify_authenticity_token,
                     if: :wuxi_authorization
  before_action :authenticate_client!

  protected

  def authenticate_client!
    token = wuxi_authorization.split("token:").last
    api_client = Api::Client.where(token: token).first
    if api_client.present?
      @current_api_client = api_client
    else
      return render(
        nothing: true,
        status: :unauthorized
      )
    end
  end

  def wuxi_authorization
    request.headers['X-Wuxi-Authorization']
  end
end

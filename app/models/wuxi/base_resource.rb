class Wuxi::BaseResource < ActiveResource::Base
  self.site = Rails.application.secrets.wuxi_api_url
  token = Rails.application.secrets.wuxi_api_token
  self.headers['X-Wuxi-Authorization'] = "Bearer token:#{token}"
end

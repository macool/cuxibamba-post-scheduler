# set host on carrierwave so that it
# responds with a full url for resources
CarrierWave.configure do |config|
  config.asset_host = Rails.application.secrets.app_url
end

Airbrake.configure do |config|
  config.host = 'http://pangi.shiriculapo.com'
  config.project_id = -1
  config.project_key = 'c30f7aacdbce66cc9d04f617d42164f0'

  config.environment = Rails.env
  config.ignore_environments = %w(development test)
end

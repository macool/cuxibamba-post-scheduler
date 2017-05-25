Airbrake.configure do |config|
  config.api_key = 'c30f7aacdbce66cc9d04f617d42164f0'
  config.host    = 'http://pangi.shiriculapo.com'
  config.port    = 80
  config.secure  = config.port == 443
end

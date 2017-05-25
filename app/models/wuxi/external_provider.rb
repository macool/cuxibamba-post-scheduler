class Wuxi::ExternalProvider < Wuxi::BaseResource
  unless Rails.env.development?
    cached_resource collection_synchronize: true
  end

  def self.active_for_api
    all.select(&:active_for_api)
  end
end

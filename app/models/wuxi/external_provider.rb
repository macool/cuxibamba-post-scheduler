class Wuxi::ExternalProvider < Wuxi::BaseResource
  unless Rails.env.development?
    cached_resource collection_synchronize: true
  end
end

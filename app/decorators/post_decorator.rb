class PostDecorator < ApplicationDecorator
  decorates_association :user

  def decorated_external_provider
    @decorated_external_provider ||= ::Wuxi::ExternalProviderDecorator.new(external_provider)
  end

  private

  def external_provider
    if external_provider_id.present?
      ::Wuxi::ExternalProvider.find(external_provider_id)
    end
  end
end

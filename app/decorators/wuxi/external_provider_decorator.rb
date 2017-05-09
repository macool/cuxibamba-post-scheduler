module Wuxi
  class ExternalProviderDecorator < ::ApplicationDecorator
    def external_link
      "https://twitter.com/#{nickname}"
    end
  end
end

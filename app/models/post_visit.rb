class PostVisit
  include Mongoid::Document

  belongs_to :post
  belongs_to :user, optional: true

  field :created_at, type: Time, default: ->{ Time.now }
  field :user_agent, type: String
  field :referer, type: String
  field :ip, type: String

  validates :post,
            presence: true
end

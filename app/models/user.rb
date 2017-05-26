class User
  include Mongoid::Document
  extend Enumerize

  devise :trackable, :omniauthable, omniauth_providers: [:twitter]

  field :uid, type: String
  field :info, type: Hash
  ## Trackable
  field :sign_in_count,      type: Integer, default: 0
  field :current_sign_in_at, type: Time
  field :last_sign_in_at,    type: Time
  field :current_sign_in_ip, type: String
  field :last_sign_in_ip,    type: String
  field :plan,               type: String
  field :display_ads,        type: Boolean

  enumerize :plan, in: [:standard, :premium], default: :standard

  index({ uid: 1 }, { unique: true })

  has_many :posts

  def self.from_omniauth(auth)
    where(uid: auth.uid).first_or_create do |user|
      user.info = auth.info
    end
  end
end

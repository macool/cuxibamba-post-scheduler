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
  field :slug,               type: String
  field :image,              type: String

  enumerize :plan, in: [:standard, :premium], default: :standard

  index({ uid: 1 }, { unique: true })
  index({ slug: 1 }, { unique: true })

  has_one :admin
  has_many :posts

  before_create :set_slug!
  before_create :set_image!

  mount_uploader :image, UserImageUploader

  def self.from_omniauth(auth)
    where(uid: auth.uid).first_or_create do |user|
      user.info = auth.info
    end
  end

  def cache_image!
    set_image!
    save!
  end

  def is_admin?
    admin.present?
  end

  private

  def set_image!
    self.remote_image_url = info["image"]
  end

  def set_slug!
    ##
    # use babosa gem
    self.slug = info["nickname"].to_slug.normalize.to_s
  end
end

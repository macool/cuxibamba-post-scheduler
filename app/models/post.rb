require "future_validator"

class Post
  include Mongoid::Document
  include Mongoid::Timestamps

  API_PERMITTED_PARAMS = [
    :tweet_id, :published
  ].freeze

  field :share_at, type: Date
  field :content, type: String
  field :published_at, type: Time
  field :tweet_id, type: String
  field :target_link, type: String
  field :external_provider_id, type: String
  field :banner, type: String
  field :auto_follow_link, type: Boolean
  field :highlight, type: Boolean, default: true

  belongs_to :user
  has_many :post_visits

  index({ published_at: 1 })
  index({ tweet_id: 1 }, { unique: true })
  index({ created_at: 1 }, { background: true })
  index({ highlight: 1 })

  mount_uploader :banner, PostBannerUploader

  validates :content,
            :external_provider_id,
            presence: true
  validates :share_at, presence: true
  validates :share_at, future: true, if: "!reposted?"

  scope :fifo, -> { order(created_at: :asc) }
  scope :published, -> { where(:published_at.ne => nil) }
  scope :unpublished, -> { where(published_at: nil) }
  scope :repost_today, -> { for_date(Time.zone.now) }
  scope :highlighted, -> { where(highlight: true) }
  scope :for_date, ->(date) { where(share_at: date.to_date) }
  scope :for_external_provider, ->(external_provider_id) {
    where(external_provider_id: external_provider_id)
  }
  scope :from_user, ->(user) {
    where(user_id: user.id)
  }
  scope :last_published, -> {
    order(published_at: :desc)
  }

  def published=(value)
    if value.present?
      self.published_at = Time.now
    end
  end

  def reposted?
    published_at.present?
  end

  def to_s
    "@#{user.decorate.nickname} - #{share_at}"
  end
end

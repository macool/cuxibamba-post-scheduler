require "future_validator"

class Post
  include Mongoid::Document
  include Mongoid::Timestamps

  field :share_at, type: Date
  field :content, type: String
  field :published_at, type: Time
  field :tweet_id, type: String
  belongs_to :user

  index({ published_at: 1 })
  index({ tweet_id: 1 }, { unique: true })

  validates :content, presence: true
  validates :share_at, presence: true, future: true

  scope :fifo, -> { order(created_at: :asc) }

  def self.next_in_queue
    fifo.where(
      published_at: nil,
      share_at: Time.zone.now.to_date
    ).first
  end
end

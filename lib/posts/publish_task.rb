module Posts
  class PublishTask
    def self.perform!
      new(Post.next_in_queue).run!
    end

    def initialize(post)
      @post = post
      @user = post.user
    end

    def run!
      tweet = TwitterService.new(
        content: @post.content,
        via: @user.info['nickname']
      ).speak!
      @post.update!(
        tweet_id: tweet.id,
        published_at: Time.now
      )
    end
  end
end

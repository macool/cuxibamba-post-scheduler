namespace :posts do
  task highlight_all: :environment do
    Post.all.each do |post|
      post.highlight = false # expire cache
      post.save
      post.highlight = true
      post.save(validate: false)
    end
  end
end

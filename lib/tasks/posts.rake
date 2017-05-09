require "posts/publish_task"

namespace :posts do
  task publish: :environment do
    Posts::PublishTask.perform!
  end
end

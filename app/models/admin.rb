class Admin
  include Mongoid::Document

  belongs_to :user
end

class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :parent, polymorphic: true

  has_many :comments, as: :parent
end

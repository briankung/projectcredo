class Comment < ApplicationRecord
  acts_as_votable
  belongs_to :user
  belongs_to :parent, polymorphic: true

  has_closure_tree

  validates :content, presence: true
end

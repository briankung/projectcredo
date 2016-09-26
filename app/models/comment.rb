class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :commentable, polymorphic: true

  has_closure_tree order: 'sort_order'
  acts_as_votable

  validates :content, presence: true
end

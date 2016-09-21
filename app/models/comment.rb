class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :parent, polymorphic: true

  has_closure_tree order: 'cached_votes_up DESC'
  acts_as_votable

  validates :content, presence: true
end

class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :parent, polymorphic: true

  has_closure_tree
end

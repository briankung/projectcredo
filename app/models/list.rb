class List < ApplicationRecord
  acts_as_taggable
  acts_as_votable
  default_scope { order updated_at: :desc }

  has_and_belongs_to_many :homepages
  belongs_to :user

  has_many :papers, through: :references
  has_many :references, dependent: :destroy
end

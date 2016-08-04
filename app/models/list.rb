class List < ApplicationRecord
  default_scope {order('updated_at DESC')}

  has_and_belongs_to_many :homepages
  belongs_to :user

  has_many :papers, through: :references
  has_many :references
end

class List < ApplicationRecord
  has_and_belongs_to_many :homepages

  has_many :papers, through: :references
  has_many :references
end

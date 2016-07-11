class Paper < ApplicationRecord
  has_and_belongs_to_many :authors
  has_many :lists, through: :references
  has_many :references
end

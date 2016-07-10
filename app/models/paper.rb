class Paper < ApplicationRecord
  has_many :lists, through: :references
  has_many :references
end

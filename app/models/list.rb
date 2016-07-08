class List < ApplicationRecord
  has_many :papers, through: :references
  has_many :references
end

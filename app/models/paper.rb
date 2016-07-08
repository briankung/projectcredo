class Paper < ApplicationRecord
  has_many :lists, through: :references
end

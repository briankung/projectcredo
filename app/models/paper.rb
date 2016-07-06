class Paper < ApplicationRecord
  has_many :lists, through: :lists_papers
end

class List < ApplicationRecord
  has_many :papers, through: :lists_papers
  has_many :lists_papers, class_name: "ListPaper"
end

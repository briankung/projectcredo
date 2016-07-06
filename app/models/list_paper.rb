class ListPaper < ApplicationRecord
  belongs_to :paper
  belongs_to :list
end

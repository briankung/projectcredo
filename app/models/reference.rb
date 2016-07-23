class Reference < ApplicationRecord
  belongs_to :paper
  belongs_to :list

  # Consider moving validations to the schema:
  # http://stackoverflow.com/a/1449466/1042144
  validates :paper, uniqueness: { scope: :list }
end

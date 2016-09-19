class Reference < ApplicationRecord
  attr_accessor :type

  has_many :comments, as: :parent

  belongs_to :paper
  belongs_to :list

  # Consider moving validations to the schema:
  # http://stackoverflow.com/a/1449466/1042144
  validates :paper, uniqueness: { scope: :list }

  acts_as_votable
end

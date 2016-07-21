class Author < ApplicationRecord
  has_and_belongs_to_many :papers
  validates :name, uniqueness: { case_sensitive: false }, presence: true
end

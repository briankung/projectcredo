class Author < ApplicationRecord
  has_and_belongs_to_many :papers
  validates :name, uniqueness: { case_sensitive: false }, presence: true

  def full_name
    "#{first_name} #{last_name}"
  end
end

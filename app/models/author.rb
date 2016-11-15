class Author < ApplicationRecord
  has_and_belongs_to_many :papers

  before_validation :set_full_name
  validates :full_name, presence: true, uniqueness: { case_sensitive: false }

  def set_full_name
    self.full_name = "#{given_name} #{family_name}"
  end
end

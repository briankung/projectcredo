class Author < ApplicationRecord
  has_and_belongs_to_many :papers
  validates :last_name,
    presence: true,
    uniqueness: {
      case_sensitive: false,
      scope: :first_name
    }

  def full_name
    "#{first_name} #{last_name}"
  end
end

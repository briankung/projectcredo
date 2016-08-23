class Publication < ApplicationRecord
  has_many :papers
  validates :name, presence: true
  before_save :downcase_name

  def downcase_name
    self.name.downcase!
  end
end

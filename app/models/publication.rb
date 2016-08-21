class Publication < ApplicationRecord
    has_many :papers
    validates :name, uniqueness: { case_sensitive: false }, presence: true
end

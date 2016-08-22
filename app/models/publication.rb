class Publication < ApplicationRecord
    has_many :papers
    validates :name, presence: true
    before_save :downcase_fields

    def downcase_fields
        self.name.downcase!
    end
end

class Link < ApplicationRecord
  belongs_to :paper
  validates :url,
    format: URI::regexp(%w(http https)),
    presence: true,
    uniqueness: {
      scope: :paper_id,
      message: "this link has already been added"
    }
end

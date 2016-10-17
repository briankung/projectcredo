class Link < ApplicationRecord
  belongs_to :paper
  validates :url, format: URI::regexp(%w(http https)), presence: true
end

class Link < ApplicationRecord
  belongs_to :paper
  validates_presence_of :url
  validate :valid_url

  def valid_url
    uri = URI.parse(url)
    errors.add(:url, "is invalid") unless uri.kind_of?(URI::HTTP)
  end
end

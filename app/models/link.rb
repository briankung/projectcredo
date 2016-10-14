class Link < ApplicationRecord
  belongs_to :paper
  validates_presence_of :link, :link_type
  validate :valid_link

  def valid_link
    uri = URI.parse(link)
    errors.add(:link, "is not a valid HTTP URL.") unless uri.kind_of?(URI::HTTP)
  end
end

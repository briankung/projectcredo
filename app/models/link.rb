class Link < ApplicationRecord
  belongs_to :paper
  validates_presence_of :link, :link_type, :paper_id
end

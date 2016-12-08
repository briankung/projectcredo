class ApiImportResponse < ApplicationRecord
  belongs_to :paper

  validates :source_uri, presence: :true

  def body
    if xml
      Nokogiri::XML(xml, &:noblanks)
    elsif json
      json
    end
  end
end

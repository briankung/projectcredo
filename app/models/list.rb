class List < ApplicationRecord
  acts_as_taggable
  acts_as_votable

  default_scope { order( cached_votes_up: :desc, updated_at: :desc ) }

  before_create :set_slug

  has_and_belongs_to_many :homepages
  belongs_to :user

  has_many :papers, through: :references
  has_many :references, dependent: :destroy

  validates :name,
            presence: true,
            uniqueness: {
                scope: :user,
                case_sensitive: false,
                message: "must be unique for lists you own."
            }

  def to_slug
    self.name.downcase.gsub(/[^\p{N}\p{L}]/, '-').gsub(/-{2,}/, '-')
  end

  def set_slug
    self.slug = self.to_slug
  end

  def set_slug!
    self.update_column :slug, self.to_slug;
  end

  def to_param
    slug
  end
end

class List < ApplicationRecord
  enum visibility: {public: 10, private: 20, contributors: 30}, _prefix: :visible_to

  acts_as_taggable
  acts_as_votable

  scope :default_sort, -> { order(cached_votes_up: :desc, updated_at: :desc) }

  before_create :set_slug

  has_and_belongs_to_many :homepages
  belongs_to :user
  has_many :list_memberships
  has_many :members, through: :list_memberships, source: :user

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
    self.name
      .downcase
      .gsub("'", '')
      .gsub(/[^\p{N}\p{L}]/, '-')
      .gsub(/-{2,}/, '-')
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

class Paper < ApplicationRecord
  acts_as_taggable
  acts_as_taggable_on :biases, :methodologies

  has_and_belongs_to_many :authors
  has_many :lists, through: :references
  has_many :references, dependent: :destroy
  belongs_to :publication

  accepts_nested_attributes_for :authors, reject_if: proc { |attributes| attributes['name'].blank? }
  accepts_nested_attributes_for :publication, reject_if: proc { |attributes| attributes['name'].blank? }
  validate :allowed_biases, :allowed_methodologies
  before_validation :find_publication

  def allowed_biases
	  invalid_biases = bias_list - valid_biases
	  invalid_biases.each {|b| errors.add(b, 'is not a supported bias') }
	end

  def allowed_methodologies
    invalid_methodologies = methodology_list - valid_methodologies
    invalid_methodologies.each {|b| errors.add(b, 'is not a supported methodology') }
  end

  def valid_biases
    [
      'selection',
      'performance',
      'detection',
      'attrition',
      'reporting',
      'small sample size'
    ]
  end

  def valid_methodologies
    [
      'meta-analysis',
      'systematic review',
      'randomized control trial',
      'quasi-experiment',
      'cohort',
      'case-control',
      'cross-sectional survey',
      'case report'
    ]
  end

  def find_publication
    if self.publication.present?
      self.publication = Publication.where(name: self.publication.name).first_or_initialize
    end
  end
end

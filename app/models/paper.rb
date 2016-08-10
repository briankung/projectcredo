class Paper < ApplicationRecord
  acts_as_taggable
  acts_as_taggable_on :biases, :methodologies

  has_and_belongs_to_many :authors
  has_many :lists, through: :references
  has_many :references, dependent: :destroy

  accepts_nested_attributes_for :authors, reject_if: proc { |attributes| attributes['name'].blank? }
  validates_associated :authors
  validate :allowed_biases, :allowed_methodologies

  def allowed_biases
	  invalid_biases = bias_list - valid_biases
	  invalid_biases.each {|b| errors.add(b, 'is not an accepted bias') }
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

  def allowed_methodologies
	  invalid_methodologies = methodology_list - valid_methodologies
	  invalid_methodologies.each {|b| errors.add(b, 'is not methodology') }
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
end

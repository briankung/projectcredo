class Paper < ApplicationRecord
  acts_as_taggable
  acts_as_taggable_on :biases, :methodologies
  ActsAsTaggableOn.strict_case_match = true

  has_and_belongs_to_many :authors
  has_many :lists, through: :references
  has_many :references, dependent: :destroy

  accepts_nested_attributes_for :authors, reject_if: proc { |attributes| attributes['name'].blank? }
  validates_associated :authors
  validate :bias_list_inclusion, :methodology_list_inclusion

  def bias_list_inclusion
    bias_list.each do |bias|
      errors.add(bias,"is not valid") unless %w(selection performance detection attrition reporting small\ sample\ size).include?(bias)
    end
  end

  def methodology_list_inclusion
    methodology_list.each do |methodology|
      errors.add(methodology,"is not valid") unless %w(meta-analysis systematic\ review randomized\ control\ trial quasi-experiment cohort case-control cross-sectional\ survey case\ report).include?(methodology)
    end
  end
end

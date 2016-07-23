class Paper < ApplicationRecord
  has_and_belongs_to_many :authors
  has_many :lists, through: :references
  has_many :references

  accepts_nested_attributes_for :authors, reject_if: proc { |attributes| attributes['name'].blank? }
  validates_associated :authors
end

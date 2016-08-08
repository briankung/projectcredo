class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_one :homepage, dependent: :destroy
  after_create -> { self.create_homepage }

  has_many :lists

  acts_as_voter
end

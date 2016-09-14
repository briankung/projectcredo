class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Virtual attribute for authenticating by either username or email
  # This is in addition to a real persisted field like 'username'
  attr_accessor :login

  validates_format_of :username, with: /^[a-zA-Z0-9_\.]*$/, multiline: true
  validates :username,
            presence: true,
            uniqueness: { case_sensitive: false }

  has_one :homepage, dependent: :destroy
  has_many :lists

  before_save { self.email.downcase! if self.email }
  after_create -> { self.create_homepage }

  acts_as_voter

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      return where(conditions.to_h).where(["username = :value OR lower(email) = :value", { :value => login.downcase }]).first
    end
    super(warden_conditions)
  end

end

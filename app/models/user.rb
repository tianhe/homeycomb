class User
  include Mongoid::Document
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  devise :omniauthable, :omniauth_providers => [:facebook]

  ## Database authenticatable
  field :email,              type: String, default: ""
  field :first_name,         type: String, default: ""
  field :last_name,          type: String, default: ""
  field :gender,             type: String, default: ""
  field :encrypted_password, type: String, default: ""

  ## Recoverable
  field :reset_password_token,   type: String
  field :reset_password_sent_at, type: Time

  ## Rememberable
  field :remember_created_at, type: Time

  ## Trackable
  field :sign_in_count,      type: Integer, default: 0
  field :current_sign_in_at, type: Time
  field :last_sign_in_at,    type: Time
  field :current_sign_in_ip, type: String
  field :last_sign_in_ip,    type: String
  field :authentication_token, type: String

  validates :email, :password, presence: true
  
  has_many  :authentications
  accepts_nested_attributes_for :authentications

  before_save :ensure_authentication_token
  before_validation :ensure_password

  before_save :ensure_search_setting

  has_many :user_listings
  
  has_one :search_setting, dependent: :destroy
  accepts_nested_attributes_for :search_setting

  
  has_one :profile, dependent: :destroy
  accepts_nested_attributes_for :profile
  delegate :mortgage_years, to: :profile
  delegate :interest_rate, to: :profile
  delegate :percent_down, to: :profile
  delegate :tax_rate, to: :profile

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end

private
  def ensure_search_setting
    self.build_search_setting unless self.search_setting
  end

  def ensure_profile
    self.build_profile unless self.profile
  end

  def ensure_password
    self.password ||= Devise.friendly_token.first(8)
  end

  def ensure_authentication_token
    self.authentication_token ||= Devise.friendly_token
  end
end

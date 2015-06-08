class Profile
  include Mongoid::Document

  field :percent_down, type: Integer, default: 20
  field :interest_rate, type: BigDecimal, default: 3.625
  field :mortgage_years, type: Integer, default: 30
  field :tax_rate, type: BigDecimal, default: 38

  belongs_to :user
  after_save :update_user_listings

  def update_user_listings
    user.user_listings.each(&:save)
  end
end
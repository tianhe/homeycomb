class SearchSetting
  include Mongoid::Document

  field :area_name,   type: String
  field :bedrooms,    type: Integer
  field :bathrooms,   type: Integer
  field :size_sqft,   type: Integer
  field :unittype_label,  type: String
  field :status,          type: String

  field :gross_monthly_cost, type: Integer, default: 10000
  field :net_monthly_cost, type: Integer, default: 10000
  field :net_monthly_cost_including_airbnb, type: Integer, default: 10000

  field :initial_cash_requirement, type: Integer, default: 1000000
  field :five_year_cash_requirement, type: Integer, default: 2000000
  
  field :hidden, type: Boolean, default: false
  field :saved, type: Boolean, default: false

  belongs_to :user

  after_save :update_user_listings

  def update_user_listings
    Listing.where()
    settings = self.attributes
    settings
  end
end
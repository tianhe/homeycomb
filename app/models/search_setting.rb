class SearchSetting
  include Mongoid::Document

  field :area_name,   type: String
  field :bedrooms,    type: Integer
  field :bathrooms,   type: Integer
  field :size_sqft,   type: Integer
  field :unittype_labels,  type: String
  field :status,          type: String

  field :gross_monthly_cost, type: Integer
  field :net_monthly_cost, type: Integer
  field :net_monthly_cost_including_airbnb, type: Integer

  field :initial_cash_requirement, type: Integer
  field :five_year_cash_requirement, type: Integer
  
  field :hidden, type: Boolean, default: false
  field :saved, type: Boolean, default: false

  belongs_to :user

  after_update :update_user_listings

  def update_user_listings
    user.user_listings.delete_all

    listings.each do |listing|
      user.user_listings.create listing: listing
    end

    retained_user_listings = user.user_listings.where(user_listing_query)
  end

  def listings
    Listing.where(listing_query)
  end


  def user_listing_query
    attrs = self.attributes
    attrs.delete('_user_id')
    attrs.delete('_id')

    fields = %w(gross_monthly_cost net_monthly_cost net_monthly_cost_including_airbnb
      initial_cash_requirement five_year_cash_requirement)
    attrs = add_selector_to_fields(attrs, fields, 'lt')    
  end

  def listing_query
    attrs = self.attributes
    attrs.delete('_user_id')
    attrs.delete('_id')

    fields = %w(bedrooms bathrooms size_sqft)
    attrs = add_selector_to_fields(attrs, fields, 'gt')
    
    fields = %w(unittype_labels)
    attrs = add_selector_to_fields(attrs, fields, 'in')
  end

  def add_selector_to_fields attrs, keys, selector
    keys.each do |key|
      attrs["#{key}.#{selector}"] = attrs.delete(key)
    end
    attrs
  end
end
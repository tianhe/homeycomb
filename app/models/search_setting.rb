class SearchSetting
  include Mongoid::Document
  include Sidekiq::Delay

  field :bedrooms,    type: Integer
  field :bathrooms,   type: Integer
  field :size_sqft,   type: Integer
  field :area_names,   type: Array, default: []
  field :unittype_labels,  type: Array, default: []
  field :statuses,          type: Array, default: []

  field :gross_monthly_cost, type: Integer
  field :net_monthly_cost, type: Integer
  field :net_monthly_cost_including_airbnb, type: Integer

  field :initial_cash_requirement, type: Integer
  field :five_year_cash_requirement, type: Integer
  
  field :hidden, type: Boolean, default: false
  field :saved, type: Boolean, default: false

  belongs_to :user

  def update_user_listings
    user.user_listings.delete_all
    listings.each do |listing|
      user.user_listings.create listing: listing
    end
  end

  def listings
    query = %w(bedrooms bathrooms size_sqft).inject({}) do |attrs, attribute|
      value = self.attributes[attribute]
      attrs[attribute.to_sym.gte] = value if value.present?
      attrs
    end
    
    query = %w(statuses unittype_labels area_names).inject(query) do |attrs, attribute|
      value = self.attributes[attribute]
      attrs[attribute.singularize.to_sym.in] = value if value.present?
      attrs
    end

    Listing.where(query)
  end

  # def out_of_range_user_listings
  #   out_of_range_query = %w(gross_monthly_cost net_monthly_cost net_monthly_cost_including_airbnb
  #     initial_cash_requirement five_year_cash_requirement).inject({}) do |attrs, attribute|
  #     value = self.attributes[attribute]
  #     attrs[attribute.to_sym.lt] = value unless value.blank?
  #     attrs
  #   end

  #   UserListing.where(out_of_range_query)
  # end

end
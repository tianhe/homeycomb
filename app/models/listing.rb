class Listing
  include Mongoid::Document

  field :title,       type: String
  field :area_name,   type: String
  field :url,         type: String
  field :bedrooms,    type: Integer
  field :bathrooms,   type: Integer
  field :half_baths,  type: Integer
  field :size_sqft,   type: Integer
  field :medium_image_uri,  type: String
  field :source_label,  type: String
  field :clean_address, type: String
  field :description_excerpt,   type: String
  field :addr_street,           type: String
  field :addr_unit,             type: String
  field :normalized_addr_unit,  type: String
  field :addr_city, type: String
  field :addr_lat,  type: String
  field :addr_lon,  type: String
  field :lot_size,  type: String
  field :ppsf,      type: Integer
  field :unittype,  type: String
  field :unittype_label,  type: String
  field :status,          type: String
  field :floorplan,       type: String
  field :price,         type: Integer
  field :maintenance,   type: Integer
  field :taxes,         type: Integer
  field :source_id,       type: String
  field :source,          type: String
  field :source_created_at,  type: String

  validates :source_id, presence: true
  validates :source, presence: true
  validates :source_id, uniqueness: { scope: :source, message: 'should be unique for source' }

  has_many :user_listings
  
  after_save :update_user_listings
  
  def update_user_listings
    
  end

  def self.import_from_street_easy street_easy_listings
    filter_fields = Listing.fields.keys
    
    street_easy_listings.each do |street_easy_listing|
      puts "#{street_easy_listing.url}"
      listing = Listing.where(source: 'StreetEasy', source_id: street_easy_listing.id).first_or_initialize
      listing.source_created_at = street_easy_listing.created_at
      
      filtered_se_listing = street_easy_listing.to_hash.slice(*filter_fields)
      listing.update(filtered_se_listing)
    end
  end  
end
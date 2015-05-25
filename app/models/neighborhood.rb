class Neighborhood
  include Mongoid::Document

  field :name, type: String
  field :street_easy_slug, type: String
  field :city, type: String
  field :state, type: String
end
class PullStreetEasyJob < ActiveJob::Base
  queue_as :default

  def perform(neighborhoods, offset=0)
    street_easy_listings = StreetEasyHelper.get_latest_listings(query_neighborhoods, offset)
    Listing.import_from_street_easy(street_easy_listings.listings)
  end
end

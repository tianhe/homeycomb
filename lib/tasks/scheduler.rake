desc "Pull StreetEasy listings Hourly"
task update_street_easy_listings: :environment do
  query_neighborhoods = StreetEasyHelper.neighborhoods.each_slice(StreetEasyHelper.neighborhoods.size/24).to_a[Time.zone.now.hour]
  puts "Update listings for #{query_neighborhoods}"
  street_easy_listings = StreetEasyHelper.get_latest_listings(query_neighborhoods)

  max_offset_index = (street_easy_listings.count/200)
  (0..max_offset_index).each do |offset| 
    PullStreetEasyJob.perform_later(query_neighborhoods, offset*200)
  end

  puts "done."
end
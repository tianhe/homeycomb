class StreetEasyHelper
  def self.get_latest_listings neighborhoods, offset=0
    StreetEasy::Property.sales.neighborhoods(neighborhoods).order(:newest).offset(offset).all
  end

  def self.areas
    %w(
      all-midtown
      all-upper-east-side
      all-upper-west-side
      all-upper-manhattan
      all-downtown
    )
  end

  def self.neighborhoods
    %w(
      battery-park-city
      chelsea
      west-chelsea
      chinatown
      two-bridges
      civic-center
      east-village
      financial-district
      fulton/seaport
      flatiron
      nomad
      gramercy-park
      greenwich-village
      noho
      little-italy
      lower-east-side
      nolita
      soho
      stuyvesant-town/pcv
      tribeca
      west-village
      central-park-south
      midtown
      midtown-east
      kips-bay
      murray-hill
      sutton-place
      turtle-bay
      beekman
      midtown-south
      midtown-west
      roosevelt-island
      carnegie-hill
      lenox-hill
      upper-carnegie-hill
      upper-east-side
      yorkville
      lincoln-square
      manhattan-valley
      morningside-heights
      upper-west-side
      central-harlem
      east-harlem
      manhattanville
      west-harlem
      bedstuy
      crown-heights
      bushwick
      williamsburg
      brownsville
      stuyvesant-heights
      ocean-hill
      clinton-hill
      dumbo
      downtown-brooklyn
      boerum-hill
      fort-greene
      cobble-hill
      vinegar-hill
      greenpoint
      prospect-heights
      brooklyn-heights
      cswd
      carroll-gardens
      red-hook
      gowanus
      park-slope
      greenwood
      crown-heights
      sunset-park
      windsor-terrace
      prospect-park-south
      flatbush
      ditmas-park
      prospect-lefferts-gardens
      northeast-flatbush
      east-new-york
      canarsie
      brownsville
      weeksville
      astoria
      long-island-city  
      sunnyside
      woodside
      jackson-heights
      maspeth
      elmhurst
      corona
      rego-park
      little-neck
      roosevelt-island
    )
  end
end
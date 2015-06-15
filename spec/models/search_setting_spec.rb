require 'rails_helper'

RSpec.describe SearchSetting, type: :model do  
  before(:each) do
    @listing = create(:listing, price: 1000000, bedrooms: 1, maintenance: 1000, taxes: 100)
    @listing2 = create(:listing, price: 100000, bedrooms: 0, maintenance: 100, taxes: 100)    
    @user = create(:user)
  end

  it 'should create no user listings by default' do
    expect(@user.user_listings).to eq([])
  end

  it 'should create new user listings based on updated criteria' do
    @user.search_setting.update(bedrooms: 0)
    expect(@user.user_listings.count).to eq(2)
  end

  it 'should hide old user listings based on updated criteria' do
    @user.search_setting.update(bedrooms: 1)
    expect(@user.user_listings.visible).to eq([@listing])
  end

  it 'should unhide hidden user listings based on updated criteria' do
    @user.user_listings.where(listing: @listing).first.update(hidden: true)
    expect(@user.user_listings.visible).to eq([@listing2])

    @user.search_setting.update(bedrooms: 1)
    expect(@user.user_listings.visible).to eq([@listing])
  end
end

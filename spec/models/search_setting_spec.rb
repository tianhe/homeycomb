require 'rails_helper'

RSpec.describe SearchSetting, type: :model do  
  before(:each) do
    @one_bedroom = create(:listing, price: 1000000, bedrooms: 1, bathrooms: 0, unittype_label: "", status: 0, size_sqft: 1000, maintenance: 1000, taxes: 100)
    @studio = create(:listing, price: 100000, bedrooms: 0, bathrooms: 0, unittype_label: "", status: 0, size_sqft: 1000, maintenance: 100, taxes: 100)    
    @user = create(:user)
  end

  it 'should create no user listings by default' do
    expect(@user.user_listings).to eq([])
  end

  it 'should only create user listings that match updated bedrooms search_setting' do
    @user.search_setting.update(bedrooms: 1)
    expect(@user.user_listings.map(&:listing)).to eq([@one_bedroom])
  end

  it 'should only create user listings that match updated bathrooms search_setting' do
    @one_bathroom = create(:listing, bathrooms: 1)
    @user.search_setting.update(bathrooms: 1)
    expect(@user.user_listings.map(&:listing)).to eq([@one_bathroom])
  end

  it 'should only create user listings that match updated size_sqft search_setting' do
    @mansion = create(:listing, size_sqft: 100000)
    @user.search_setting.update(size_sqft: 100000)
    expect(@user.user_listings.map(&:listing)).to eq([@mansion])

    @user.reload
    @user.search_setting.update(size_sqft: 99999)    
    expect(@user.user_listings.map(&:listing)).to eq([@mansion])    
  end

  it 'should only create user listings that match updated area_names search_setting' do
    @bed_stuy2 = create(:listing, area_name: 'BedStuy')
    @bed_stuy1 = create(:listing, area_name: 'BedStuy')
    @williamsburg = create(:listing, area_name: 'Williamsburg')

    @user.search_setting.update(area_names: ['Williamsburg', 'BedStuy'])
    expect(@user.user_listings.map(&:listing).to_set).to eq([@bed_stuy1, @bed_stuy2, @williamsburg].to_set)

    @user.reload
    @user.search_setting.update(area_names: ['Bronx'])
    expect(@user.user_listings.map(&:listing)).to eq([])
  end

  it 'should only create user listings that match updated unittype_labels search_setting' do
    @condo1 = create(:listing, unittype_label: 'Condo')
    @condo2 = create(:listing, unittype_label: 'Condo')
    @coop = create(:listing, unittype_label: 'Coop')

    @user.search_setting.update(unittype_labels: ['Condo', 'Coop'])
    expect(@user.user_listings.map(&:listing).to_set).to eq([@condo1, @condo2, @coop].to_set)

    @user.reload
    @user.search_setting.update(unittype_labels: ['Townhouse'])
    expect(@user.user_listings.map(&:listing)).to eq([])    
  end

  it 'should only create user listings that match updated statuses search_setting' do
    @available1 = create(:listing, status: 1)
    @available2 = create(:listing, status: 1)
    @in_contract = create(:listing, status: 2)

    @user.search_setting.update(statuses: [1, 2])
    expect(@user.user_listings.map(&:listing).to_set).to eq([@available1, @available2, @in_contract].to_set)

    @user.reload
    @user.search_setting.update(statuses: [3])
    expect(@user.user_listings.map(&:listing)).to eq([])    
  end
end

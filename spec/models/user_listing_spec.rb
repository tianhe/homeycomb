require 'rails_helper'

RSpec.describe UserListing, type: :model do
  let(:user) { create(:user) }

  context '#validation' do
    it 'should be invalid if gross_monthly_cost > search setting' do
      user.search_setting.update gross_monthly_cost: 999
      listing = create(:listing, price: 1000000, maintenance: 1000, taxes: 100)
      
      user_listing = build(:user_listing, user: user, listing: listing)

      user_listing.valid?      
      expect(user_listing.errors[:gross_monthly_cost]).to eq(['too high'])
    end

    it 'should be invalid if initial_cash_requiremnt > search setting' do
      user.search_setting.update initial_cash_requirement: 999
      listing = create(:listing, price: 1000000, maintenance: 1000, taxes: 100)
      
      user_listing = build(:user_listing, user: user, listing: listing)

      user_listing.valid?      
      expect(user_listing.errors[:initial_cash_requirement]).to eq(['too high'])      
    end

    it 'should be invalid if net_monthly_cost > search setting' do
      user.search_setting.update net_monthly_cost: 999
      listing = create(:listing, price: 1000000, maintenance: 1000, taxes: 100)
      
      user_listing = build(:user_listing, user: user, listing: listing)

      user_listing.valid?      
      expect(user_listing.errors[:net_monthly_cost]).to eq(['too high'])            
    end

    it 'should be invalid if net_monthly_cost_including_airbnb > search setting' do
      user.search_setting.update net_monthly_cost_including_airbnb: 999
      listing = create(:listing, price: 1000000, maintenance: 1000, taxes: 100)
      
      user_listing = build(:user_listing, user: user, listing: listing)

      user_listing.valid?      
      expect(user_listing.errors[:net_monthly_cost_including_airbnb]).to eq(['too high'])            
    end

    it 'should be invalid if five_year_cash_requirement > search setting' do
      user.search_setting.update five_year_cash_requirement: 999
      listing = create(:listing, price: 1000000, maintenance: 1000, taxes: 100)
      
      user_listing = build(:user_listing, user: user, listing: listing)

      user_listing.valid?      
      expect(user_listing.errors[:five_year_cash_requirement]).to eq(['too high'])            
    end

    it 'should be invalid if area_name is not in search_setting' do
      user.search_setting.update area_names: ['BedStuy']
      listing = create(:listing, area_name: 'Bushwick')
      
      user_listing = build(:user_listing, user: user, listing: listing)

      user_listing.valid?      
      expect(user_listing.errors[:area_name]).to eq(['doesnt match search setting'])
    end

    it 'should be invalid if bathrooms is not in search_setting' do
      user.search_setting.update bathrooms: 1
      listing = create(:listing, bathrooms: 0)
      
      user_listing = build(:user_listing, user: user, listing: listing)

      user_listing.valid?      
      expect(user_listing.errors[:bathrooms]).to eq(['too few'])
    end

    it 'should be invalid if bedrooms is not in search_setting' do
      user.search_setting.update bedrooms: 1
      listing = create(:listing, bedrooms: 0)
      
      user_listing = build(:user_listing, user: user, listing: listing)

      user_listing.valid?      
      expect(user_listing.errors[:bedrooms]).to eq(['too few'])
    end

    it 'should be invalid if status is not in search_setting' do
      user.search_setting.update statuses: [1]
      listing = create(:listing, status: 2)
      
      user_listing = build(:user_listing, user: user, listing: listing)

      user_listing.valid?      
      expect(user_listing.errors[:status]).to eq(['doesnt match search setting'])

    end

    it 'should be invalid if unittype_label is not in search_setting' do
      user.search_setting.update unittype_labels: ['Condo']
      listing = create(:listing, status: 2)
      
      user_listing = build(:user_listing, user: user, listing: listing)

      user_listing.valid?
      expect(user_listing.errors[:unittype_label]).to eq(['doesnt match search setting'])

    end

    it 'should be invalid if size_sqft is not in search_setting' do
      user.search_setting.update size_sqft: 1000
      listing = create(:listing, size_sqft: 999)
      
      user_listing = build(:user_listing, user: user, listing: listing)

      user_listing.valid?      
      expect(user_listing.errors[:size_sqft]).to eq(['too small'])
    end
  end

  context '#calculations' do
    it 'should calculate initial cash requirement' do
      listing = create(:listing, price: 1000000, maintenance: 1000, taxes: 100)
      user_listing = create(:user_listing, listing: listing, percent_down: 20)

      expect(user_listing.initial_cash_requirement).to eq(200000)
    end

    it 'should calculate monthly_cost' do
      listing = create(:listing, price: 1000000, maintenance: 1000, taxes: 100)
      user_listing = create(:user_listing, listing: listing, percent_down: 20, mortgage_years: 30, interest_rate: 3.625, tax_rate: 25)
      
      expect(user_listing.mortgage).to eq(3648)
      expect(user_listing.gross_monthly_cost).to eq(4748)
      expect(user_listing.net_monthly_cost).to eq(4419)
    end

    it 'should calculate airbnb profit' do
      listing = create(:listing, price: 1000000, maintenance: 1000, taxes: 100)
      user_listing = create(:user_listing, listing: listing, percent_down: 20, mortgage_years: 30, interest_rate: 3.625, tax_rate: 25, airbnb_daily_total: 100, airbnb_fill_days: 10)

      expect(user_listing.airbnb_monthly_gross_profit).to eq(1000)
      expect(user_listing.net_monthly_cost_including_airbnb).to eq(3669)
    end

    it 'should calculate five year cash requirement' do
      listing = create(:listing, price: 1000000, maintenance: 1000, taxes: 100)
      user_listing = create(:user_listing, listing: listing, percent_down: 20, mortgage_years: 30, interest_rate: 3.625, tax_rate: 25, airbnb_daily_total: 100, airbnb_fill_days: 10)

      expect(user_listing.five_year_cash_requirement).to eq(200000 + 220140)
    end

    it 'should calculate rental income' do
      listing = create(:listing, price: 1000000, maintenance: 1000, taxes: 100)
      user_listing = create(:user_listing, listing: listing, gross_monthly_rental_income: 1000, tax_rate: 25)
      expect(user_listing.net_monthly_rental_income).to eq(750)
    end

    it 'should calculate rent to cost' do
      listing = create(:listing, price: 1000000, maintenance: 1000, taxes: 100)
      user_listing = create(:user_listing, listing: listing, gross_monthly_rental_income: 1000, percent_down: 20, mortgage_years: 30, interest_rate: 3.625, tax_rate: 25, airbnb_daily_total: 100, airbnb_fill_days: 10)
      expect(user_listing.rent_to_cost).to eq(750.0/user_listing.net_monthly_cost)
    end

    it 'should calculate return on capital' do
      listing = create(:listing, price: 1000000, maintenance: 1000, taxes: 100)
      user_listing = create(:user_listing, listing: listing, gross_monthly_rental_income: 1000, percent_down: 20, mortgage_years: 30, interest_rate: 3.625, tax_rate: 25, airbnb_daily_total: 100, airbnb_fill_days: 10)
      
      return_on_capital = listing.price*(1.03)**30 / (user_listing.net_monthly_cost*12*30) - 1.0
      expect(user_listing.return_on_capital).to eq(return_on_capital)
    end
  end

  it 'should calculate return on capital with airbnb' do
    listing = create(:listing, price: 1000000, maintenance: 1000, taxes: 100)
    user_listing = create(:user_listing, listing: listing, gross_monthly_rental_income: 1000, percent_down: 20, mortgage_years: 30, interest_rate: 3.625, tax_rate: 25, airbnb_daily_total: 100, airbnb_fill_days: 10)
    
    return_on_capital = listing.price*(1.03)**30 / (user_listing.net_monthly_cost_including_airbnb*12*30) - 1.0
    expect(user_listing.return_on_capital_including_airbnb).to eq(return_on_capital)
  end

end

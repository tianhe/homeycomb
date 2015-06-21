require 'rails_helper'

RSpec.describe UserListing, type: :model do

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

  it 'should calculate return on capital with airbnb' do
    listing = create(:listing, price: 1000000, maintenance: 1000, taxes: 100)
    user_listing = create(:user_listing, listing: listing, gross_monthly_rental_income: 1000, percent_down: 20, mortgage_years: 30, interest_rate: 3.625, tax_rate: 25, airbnb_daily_total: 100, airbnb_fill_days: 10)
    
    return_on_capital = listing.price*(1.03)**30 / (user_listing.net_monthly_cost_including_airbnb*12*30) - 1.0
    expect(user_listing.return_on_capital_including_airbnb).to eq(return_on_capital)
  end

end

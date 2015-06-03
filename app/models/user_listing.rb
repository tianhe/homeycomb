class UserListing
  include Mongoid::Document

  field :percent_down, type: Integer, default: 20
  field :interest_rate, type: BigDecimal, default: 0.03625
  field :mortgage_years, type: Integer, default: 30
  field :mortgage, type: Integer, default: 0
  field :tax_rate, type: BigDecimal, default: 0.25
  field :gross_monthly_cost, type: Integer, default: 0
  field :net_monthly_cost, type: Integer, default: 0
  field :airbnb_daily_total, type: Integer, default: 100.0
  field :airbnb_fill_days, type: Integer, default: 0
  field :airbnb_monthly_gross_profit, type: Integer, default: 0
  field :net_monthly_cost_including_airbnb, type: Integer, default: 0
  field :initial_cash_requirement, type: Integer, default: 0
  field :five_year_cash_requirement, type: Integer, default: 0
  field :gross_monthly_rental_income, type: Integer, default: 0
  field :net_monthly_rental_income, type: Integer, default: 0
  field :rent_to_cost, type: BigDecimal, default: 0
  field :return_on_capital, type: BigDecimal, default: 0
  field :return_on_capital_including_airbnb, type: BigDecimal, default: 0

  field :closing_cost_percent, type: BigDecimal
  field :listing_id

  belongs_to :listing
  belongs_to :user

  validates :percent_down, presence: true
  validates :interest_rate, presence: true
  validates :mortgage, presence: true
  validates :tax_rate, presence: true
  validates :initial_cash_requirement, presence: true
  validates :five_year_cash_requirement, presence: true
  validates :gross_monthly_rental_income, presence: true
  validates :net_monthly_rental_income, presence: true
  validates :rent_to_cost, presence: true
  validates :return_on_capital, presence: true

  before_save :calculate_initial_cash_requirement
  before_save :calculate_monthly_cost
  before_save :calculate_airbnb_profit
  before_save :calculate_five_year_cash_requirement

  before_save :calculate_rental_income
  before_save :calculate_rent_to_cost
  before_save :calculate_return_on_capital
  before_save :calculate_return_on_capital_including_airbnb

  def calculate_initial_cash_requirement
    self.initial_cash_requirement = percent_down/100.0*listing.price
  end

  def calculate_monthly_cost
    self.mortgage = listing.price*(1-percent_down/100.0)*(interest_rate/12.0*(1+interest_rate/12.0)**(mortgage_years*12.0))/((1.0+interest_rate/12.0)**(mortgage_years*12)-1.0)
    self.gross_monthly_cost = self.mortgage + listing.maintenance + listing.taxes
    self.net_monthly_cost = self.gross_monthly_cost - listing.taxes*tax_rate - mortgage/3*tax_rate
  end

  def calculate_airbnb_profit
    self.airbnb_monthly_gross_profit = airbnb_daily_total * airbnb_fill_days  
    self.net_monthly_cost_including_airbnb = net_monthly_cost - airbnb_monthly_gross_profit*(1-tax_rate)
  end

  def calculate_five_year_cash_requirement
    self.five_year_cash_requirement = initial_cash_requirement + net_monthly_cost_including_airbnb*12*5
  end

  def calculate_rental_income
    self.net_monthly_rental_income = gross_monthly_rental_income * (1-tax_rate)
  end

  def calculate_rent_to_cost
    self.rent_to_cost = net_monthly_rental_income.to_f / net_monthly_cost
  end

  def calculate_return_on_capital
    self.return_on_capital = listing.price*(1.03)**30 / (self.net_monthly_cost*12*30) - 1.0
  end

  def calculate_return_on_capital_including_airbnb
    self.return_on_capital_including_airbnb = listing.price*(1.03)**30 / (self.net_monthly_cost_including_airbnb*12*30) - 1.0
  end
end
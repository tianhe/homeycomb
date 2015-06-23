class UserListing
  include Mongoid::Document

  field :percent_down, type: Integer
  field :interest_rate, type: BigDecimal
  field :mortgage_years, type: Integer
  field :tax_rate, type: BigDecimal

  field :mortgage, type: Integer, default: 0  
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
  field :hidden, type: Boolean, default: false
  field :saved, type: Boolean, default: false
  
  delegate :area_name, to: :listing
  delegate :url, to: :listing
  delegate :title, to: :listing
  delegate :bedrooms, to: :listing
  delegate :bathrooms, to: :listing
  delegate :status, to: :listing
  delegate :size_sqft, to: :listing
  delegate :unittype_label, to: :listing
  delegate :price, to: :listing
  delegate :ppsf, to: :listing

  field :closing_cost_percent, type: BigDecimal

  belongs_to :listing
  belongs_to :user

  validates :listing_id, uniqueness: { scope: :user_id, message: 'should be unique for each user' }

  validates :percent_down, presence: true
  validates :interest_rate, presence: true
  validates :mortgage, presence: true
  validates :tax_rate, presence: true

  validate :satisfy_search_setting

  validates :initial_cash_requirement, presence: true
  validates :gross_monthly_rental_income, presence: true
  validates :net_monthly_rental_income, presence: true
  validates :five_year_cash_requirement, presence: true
  validates :rent_to_cost, presence: true
  validates :return_on_capital, presence: true
  validates :listing_id, presence: true
  validates :user_id, presence: true

  before_validation :set_values_based_on_profile
  before_validation :calculate_initial_cash_requirement
  before_validation :calculate_monthly_cost
  before_validation :calculate_airbnb_profit
  before_validation :calculate_five_year_cash_requirement

  before_validation :calculate_rental_income
  before_validation :calculate_rent_to_cost
  before_validation :calculate_return_on_capital
  before_validation :calculate_return_on_capital_including_airbnb

  scope :visible, -> { where(hidden: false) }
  # scope :on_market, -> { joins(:listings).where() }
  # scope :in_contract, -> { joings(:listings).where() }

  def satisfy_search_setting
    if user.gross_monthly_cost && user.gross_monthly_cost <= self.gross_monthly_cost
      errors.add(:gross_monthly_cost, 'too high')
    end

    if user.net_monthly_cost && user.net_monthly_cost <= self.net_monthly_cost
      errors.add(:net_monthly_cost, 'too high')
    end

    if user.net_monthly_cost_including_airbnb && user.net_monthly_cost_including_airbnb <= self.net_monthly_cost_including_airbnb
      errors.add(:net_monthly_cost_including_airbnb, 'too high')
    end

    if user.initial_cash_requirement && user.initial_cash_requirement <= self.initial_cash_requirement
      errors.add(:initial_cash_requirement, 'too high')
    end

    if user.five_year_cash_requirement && user.five_year_cash_requirement <= self.five_year_cash_requirement
      errors.add(:five_year_cash_requirement, 'too high')
    end

    if user.area_names.present? && !user.area_names.include?(self.area_name)
      errors.add(:area_name, 'doesnt match search setting')
    end

    if user.statuses.present? && !user.statuses.include?(self.status)
      errors.add(:status, 'doesnt match search setting')
    end

    if user.unittype_labels.present? && !user.unittype_labels.include?(self.unittype_label)
      errors.add(:unittype_label, 'doesnt match search setting')
    end

    if user.size_sqft.present? && user.size_sqft >= self.size_sqft
      errors.add(:size_sqft, 'too small')
    end

    if user.bedrooms.present? && user.bedrooms >= self.bedrooms
      errors.add(:bedrooms, 'too few')
    end

    if user.bathrooms.present? && user.bathrooms >= self.bathrooms
      errors.add(:bathrooms, 'too few')
    end

  end

  def set_values_based_on_profile
    self.percent_down ||= [listing.minimum_percent_down || 0, user.percent_down].max
    self.mortgage_years ||= user.mortgage_years
    self.interest_rate ||= user.interest_rate
    self.tax_rate ||= user.tax_rate
  end

  def calculate_initial_cash_requirement
    self.initial_cash_requirement = percent_down/100.0*listing.price
  end

  def calculate_monthly_cost
    self.mortgage = listing.price*(1-percent_down/100.0)*(interest_rate/100/12.0*(1+interest_rate/100/12.0)**(mortgage_years*12.0))/((1.0+interest_rate/100/12.0)**(mortgage_years*12)-1.0)
    self.gross_monthly_cost = self.mortgage + listing.maintenance + listing.taxes
    self.net_monthly_cost = self.gross_monthly_cost - listing.taxes*tax_rate/100 - mortgage/3*tax_rate/100
  end

  def calculate_airbnb_profit
    self.airbnb_monthly_gross_profit = airbnb_daily_total * airbnb_fill_days  
    self.net_monthly_cost_including_airbnb = net_monthly_cost - airbnb_monthly_gross_profit*(1-tax_rate/100)
  end

  def calculate_five_year_cash_requirement
    self.five_year_cash_requirement = initial_cash_requirement + net_monthly_cost_including_airbnb*12*5
  end

  def calculate_rental_income
    self.net_monthly_rental_income = gross_monthly_rental_income * (1-tax_rate/100)
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
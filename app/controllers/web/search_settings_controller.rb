class Web::SearchSettingsController < ApplicationController
  before_action :find_search_setting

  def edit
  end

  def update    
    if @search_setting.update search_setting_params
      @search_setting.delay.update_user_listings
      flash[:notice] = 'Update succeeded'
    else
      flash[:error] = 'Update failed'
    end

    redirect_to edit_search_setting_path(params[:id])
  end

  private

  def find_search_setting
    @search_setting = current_user.search_setting
  end  

  def search_setting_params
    params[:search_setting][:statuses] = params[:search_setting][:statuses].present? ? params[:search_setting][:statuses].split(",")  : []
    params[:search_setting][:area_names] = params[:search_setting][:area_names].present? ? params[:search_setting][:area_names].split(",") : []
    params[:search_setting][:unittype_labels] = params[:search_setting][:unittype_labels].present? ? params[:search_setting][:unittype_labels].split(",") : []
    params.require(:search_setting).permit(:bedrooms, :bathrooms, :size_sqft, :gross_monthly_cost, :net_monthly_cost, :net_monthly_cost_including_airbnb, :initial_cash_requirement, :five_year_cash_requirement, :hidden, :saved, statuses: [], area_names: [], unittype_labels: [])
  end
end
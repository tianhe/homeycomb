class Web::SearchSettingsController < ApplicationController
  before_action :find_search_setting

  def edit
  end

  def update
    if @search_setting.update search_setting_params
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
    params.require(:search_setting).permit(:status, :area_name, :unittype_label, :bedrooms, :bathrooms, :size_sqft, :gross_monthly_cost, :net_monthly_cost, :net_monthly_cost_including_airbnb, :initial_cash_requirement, :five_year_cash_requirement, :hidden, :saved)
  end
end
class Web::ProfilesController < ApplicationController
  before_action :find_profile

  def edit
  end

  def update
    if @profile.update profile_params
      flash[:notice] = 'Update succeeded'
    else
      flash[:error] = 'Update failed'
    end
    redirect_to edit_profile_path(@profile)
  end

  private

  def find_profile
    @profile = current_user.profile
  end

  def profile_params
    params.require(:profile).permit(:mortgage_years, :tax_rate, :percent_down, :interest_rate)
  end
end
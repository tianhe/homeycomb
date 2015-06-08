class Web::UserListingsController < ApplicationController
  before_action :find_user_listing, except: [:index]

  def index
    @user_listings = current_user.user_listings

    @user_listings = @user_listings.order_by(sort_params).page(params[:page]||0).per(params[:page_size]||10)
  end

  def edit
  end

  def update
    if @user_listing.update user_listing_params
      flash[:notice] = 'Update succeeded'
    else
      flash[:error] = 'Update failed'
    end
    redirect_to user_listings_path
  end

  def destroy
    @user_listing.update(hidden: true)
    redirect_to user_listings_path
  end

  private

  def find_user_listing
    unless (@user_listing = current_user.user_listings.where(id: params[:id]).first)
      flash[:error] = 'record not found'
      redirect_to :index and return
    end
  end

  def sort_params
    if params[:order]
      [params[:order], :asc]
    else
      [:net_monthly_cost, :asc]
    end
  end

  def user_listing_params
    params.require(:user_listing).permit(:percent_down, :interest_rate, :airbnb_daily_total, :airbnb_fill_days, :saved, :hidden)
  end
end
class Web::UserListingsController < ApplicationController
  def index
    @user_listings = current_user.user_listings
    @user_listings = @user_listings.order_by(params[:order]||[:price, :desc]).page(params[:page]||0).per(params[:page_size]||10)
  end

  private

end
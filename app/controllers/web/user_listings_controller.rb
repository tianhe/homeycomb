class Web::UserListingsController < ApplicationController
  def index
    @user_listings = current_user.user_listings
  end
end
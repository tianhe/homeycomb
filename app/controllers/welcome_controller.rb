class WelcomeController < ApplicationController
  def index
    redirect_to user_listings_path if user_signed_in?
  end
end

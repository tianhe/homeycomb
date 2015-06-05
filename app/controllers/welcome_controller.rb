class WelcomeController < ApplicationController
  def index
    redirect_to '/web/user_listings' if user_signed_in?
  end
end

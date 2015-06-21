require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:authentications) }

  it 'should set an authentication token' do
    @user = create(:user)
    expect(@user.authentication_token).not_to be_nil
  end

  it 'should create a profile' do
    @user = create(:user)
    expect(@user.profile).not_to be_nil
  end

  it 'should create a search setting' do
    @user = create(:user)
    expect(@user.search_setting).not_to be_nil
  end
end

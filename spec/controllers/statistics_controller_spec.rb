require 'spec_helper'

describe StatisticsController do
    render_views  

    it "should get statistics" do
       user = FactoryGirl.create(:user)
      sign_in user
      get :show
    end
end 

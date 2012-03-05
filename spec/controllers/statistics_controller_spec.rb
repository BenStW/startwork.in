require 'spec_helper'

describe StatisticsController do
    render_views  
    fixtures :users

    it "should get statistics" do
      sign_in users(:ben)
      get :show
    end
end 

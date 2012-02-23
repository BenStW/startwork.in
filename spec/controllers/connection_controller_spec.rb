require 'spec_helper'

describe ConnectionController do

  describe "GET 'end'" do
    it "returns http success" do
      get 'end'
      response.should be_success
    end
  end

end

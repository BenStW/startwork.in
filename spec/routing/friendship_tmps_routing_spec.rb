require "spec_helper"

describe FriendshipTmpsController do
  describe "routing" do

    it "routes to #index" do
      get("/friendship_tmps").should route_to("friendship_tmps#index")
    end

    it "routes to #new" do
      get("/friendship_tmps/new").should route_to("friendship_tmps#new")
    end

    it "routes to #show" do
      get("/friendship_tmps/1").should route_to("friendship_tmps#show", :id => "1")
    end

    it "routes to #edit" do
      get("/friendship_tmps/1/edit").should route_to("friendship_tmps#edit", :id => "1")
    end

    it "routes to #create" do
      post("/friendship_tmps").should route_to("friendship_tmps#create")
    end

    it "routes to #update" do
      put("/friendship_tmps/1").should route_to("friendship_tmps#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/friendship_tmps/1").should route_to("friendship_tmps#destroy", :id => "1")
    end

  end
end

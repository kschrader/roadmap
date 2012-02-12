require 'spec_helper'

describe FeaturesController do
  include BilgePump::Specs

  def attributes_for_create
    { name: "Created Feature" }
  end

  def attributes_for_update
    { name: "Updated Feature" }
  end

  describe "PUT refresh" do
    let (:stories) {
      2.times do 
        Factory.build :tracker_story
      end
    }
    
    it "works" do
      TrackerIntegration.should_receive(:update_stories)
      put :refresh
      response.should be_redirect
    end
  end

  describe "GET tagged" do
    it "returns 200 OK" do
      get :tagged, value: "red"
      response.should be_success
    end

    it "assigns fetched features into @features" do
      red_feature1 = Factory :feature, labels: ["red"]
      red_feature2 = Factory :feature, labels: ["red"]
      blue_feature = Factory :feature, labels: ["blue"]

      get :tagged, value: "red"
      assigns(:features).should == [red_feature1, red_feature2]
    end
  end

end

require 'spec_helper'

describe FeaturesController do
  include BilgePump::Specs

  def attributes_for_create
    { name: "Created Feature" }
  end

  def attributes_for_update
    { name: "Updated Feature" }
  end
  
  describe "GET tagged" do
    it "returns 200 OK" do
      # /features/tagged/red
      get :tagged, value: "red"
      response.should be_success
    end

    it "returns 200 OK" do
      # /features/tagged/red.blue
      get :tagged, value: "red.blue"
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

  describe "schedule" do
    it "creates the feature in tracker" do 
      new_story = Factory.build :tracker_story
      TrackerIntegration.stub(:create_feature_in_tracker).and_return(new_story)
           
      feature_to_schedule = 
        Factory :feature, story_id: nil
      
      # PUT /features/run_schedule [params]
      put :schedule,
        :feature_id => feature_to_schedule.id
      
      assigns(:feature).story_id.should_not be_nil
    end
  end
end

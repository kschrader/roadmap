require 'spec_helper'

describe FeaturesController do
  include BilgePump::Specs

  model_scope [:project]
  model_class Feature

  def attributes_for_create
    { name: "Created Feature" }
  end

  def attributes_for_update
    { name: "Updated Feature" }
  end
  let (:project) {Factory :project}
  describe "GET tagged" do
   

    it "returns 200 OK" do
      # /features/tagged/red
      get :tagged, project_id: project.id, value: "red"
      response.should be_success
    end

    it "accepts dots in params" do
      # /features/tagged/red.blue
      get :tagged, project_id: project.id, value: "red.blue"
      response.should be_success
    end

    it "assigns fetched features into @features" do
      red_feature1 = Factory :feature, labels: ["red"], project_id: project.id
      red_feature2 = Factory :feature, labels: ["red"], project_id: project.id
      blue_feature = Factory :feature, labels: ["blue"], project_id: project.id

      get :tagged, project_id: project.id, value: "red"
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
      put :schedule, project_id: project.id,
        :feature_id => feature_to_schedule.id
      
      assigns(:feature).story_id.should_not be_nil
    end
  end
end

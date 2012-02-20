require 'spec_helper'

describe TrackerIntegration do

  describe "update_stories" do
    let (:story1) { Factory.build :tracker_story}
    let (:story2) { Factory.build :tracker_story}

    let (:feature1) { Factory :feature, name: "Old Value", tracker_id: story1.id}

    it "updates features from stories" do
      feature1.name.should == "Old Value"
      TrackerIntegration.update_stories([story1])
      feature1.reload.name.should == story1.name
    end

    it "inserts features for new stories" do
      feature2 = Feature.find_by_tracker_id(story2.id)
      feature2.should_not be_present

      TrackerIntegration.update_stories([story2])

      feature2 = Feature.find_by_tracker_id(story2.id)
      feature2.should be_present
      feature2.name.should == story2.name
    end
  end

  describe "create_feature_in_tracker" do
    

    it "creates a story in Tracker for a feature" do
      new_story = Factory.build :tracker_story
      
      # Need to add your token  
      token = "456ad1aa5ef09b45a72a15e5e13b8f68"
      test_project_id = 477483

      feature = Factory :feature, tracker_id: nil
      TrackerIntegration.stub(:create_feature_in_tracker).and_return(feature)
      PivotalTracker::Client.token = token
      new_story = TrackerIntegration.create_feature_in_tracker(token, test_project_id, feature)

      new_story.should_not be_nil
      
      new_story.name.should == feature.name
      new_story.estimate.should == feature.estimate
      new_story.labels.should == feature.labels
      new_story.description.should == feature.description

    end


  end

end
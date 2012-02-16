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

    xit "creates a story in Tracker for a feature" do
      # Need to add your token  
      TOKEN = ""
      TEST_PROJECT_ID = 477483

      feature = Factory :feature, tracker_id: nil
      
      PivotalTracker::Client.token = TOKEN
      new_story = TrackerIntegration.create_feature_in_tracker(TOKEN, TEST_PROJECT_ID, feature)

      new_story.should_not be_nil
      
      new_story.name.should == feature.name
      new_story.estimate.should == feature.estimate
      new_story.labels.should == feature.labels.sort.join(',')
      new_story.description.should == feature.description

    end

    xit "doesn't create if it's already in tracker" do
      feature = Factory :feature, tracker_id: 100
    end

    xit "has all the latest from Tracker in the feature afterwards" do
    end

  end

end
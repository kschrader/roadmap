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

end
require 'spec_helper'

describe TrackerIntegration do

  describe "update_stories" do
    let (:story1) { Factory.build :tracker_story}
    let (:story2) { Factory.build :tracker_story}

    let (:feature1) { Factory :feature, name: "Old Value", story_id: story1.id}

    it "updates features from project" do
      project = Factory :project, id: 1000, name: "Old Value"
      project2 = Factory.build :project, id: 1000,name: "New Value"
      project.name.should == "Old Value"
      TrackerIntegration.update_stories([story1],project2)
      project.reload.name.should == project2.name
    end

    it "updates features from stories" do
      feature1.name.should == "Old Value"
      TrackerIntegration.update_stories([story1],story1)
      feature1.reload.name.should == story1.name
    end

    it "inserts features for new stories" do
      feature2 = Feature.find_by_story_id(story2.id)
      feature2.should_not be_present

      TrackerIntegration.update_stories([story2],story2)

      feature2 = Feature.find_by_story_id(story2.id)
      feature2.should be_present
      feature2.name.should == story2.name
    end
  end

  describe "check if tracker deleted" do
    it "sets type as deleted" do
      story1 = Factory.build :tracker_story
      feature = Factory :feature , :refreshed_at => Time.new(2009,1,03),:tracker_project_id => story1.id
      refresh_time = Time.new(2012,2,03)

      TrackerIntegration.mark_deleted_features(story1,refresh_time)
      
      feature.reload
      feature.story_type.should == "Deleted"

    end

  end


  describe "create_feature_in_tracker" do
    it "Gets project and feature ready to be created" do
      test_project_id = 477483

      feature = Factory :feature, story_id: nil
      
      some_fake_project = PivotalTracker::Project.new
      PivotalTracker::Project.stub(:find).and_return(some_fake_project)

      some_tracker_story = Factory.build :tracker_story
      TrackerIntegration.should_receive(:create_story_for_project).with(some_fake_project, feature).and_return(some_tracker_story)

      new_story = TrackerIntegration.create_feature_in_tracker(test_project_id, feature)

      new_story.should == some_tracker_story
    end

    it "creates a story in Tracker for a feature" do
      class ClassWithCreate
        def create(stuff)
        end
      end
      feature = Factory :feature, story_id: nil      
      project = PivotalTracker::Project.new
      the_create_method = ClassWithCreate.new
      some_tracker_story = Factory.build :tracker_story
     

      project.should_receive(:stories).and_return(the_create_method)
      the_create_method.should_receive(:create).with(name: feature.name, estimate: feature.estimate, labels: feature.labels, description: feature.description).and_return(some_tracker_story)
      new_story = TrackerIntegration.create_story_for_project(project, feature)

      new_story.should == some_tracker_story
    end
  end
end
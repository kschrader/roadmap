require 'spec_helper'

describe Feature do
  describe "validation" do
    it 'requires name' do
      Factory.build(:feature, name: nil).should_not be_valid
    end
  end

  describe "accepted_in_period" do
    let (:jan_feature) { Factory :feature, accepted_at: DateTime.new(2012,01,15) }
    let (:feb_feature) { Factory :feature, accepted_at: DateTime.new(2012,02,15) }

    it "finds" do
      period_begin = DateTime.new(2012, 1, 14).to_time
      period_end = DateTime.new(2012, 1, 15).to_time

      found = Feature.accepted_in_period(period_begin, period_end)
      found.should include jan_feature
      found.should_not include feb_feature
    end
 end

  describe "with_label" do
    let (:red_one) { Factory(:feature, labels: ['red', 'black'])}
    let (:blue_one) { Factory(:feature, labels: ['blue', 'brown'])}

    it "finds on single string" do
      Feature.with_label('red').should include red_one
      Feature.with_label('blue').should include blue_one
    end

    it "finds with array arguments" do
      both = Feature.with_label(['black', 'brown'])
      both.should include red_one
      both.should include blue_one

      red_only = Feature.with_label(['red', 'green'])
      red_only.should include red_one
      red_only.should_not include blue_one
    end

  end

  describe "update" do
    describe "from story" do

      let(:story) { Factory.build :tracker_story, accepted_at: Time.utc(2012, 2, 10) }
      let(:subject) { (Factory :feature).update(story)}

      it "is valid" do
        subject.should be_valid
      end

      it "sets refreshed_at" do
        feature = Factory.build :feature, refreshed_at: nil
        feature.update( Factory.build :tracker_story )
        feature.refreshed_at.should be_present
      end

      it "string fields work" do
        TrackerIntegration::Story::StringFields.each do |field|
          subject.send(field).should == story.send(field)
        end
      end

      it "array fields work" do
        TrackerIntegration::Story::ArrayFields.each do |field|
          subject.send(field).should == story.send(field).split(',')
        end
      end

      it "numeric fields work" do
        TrackerIntegration::Story::NumericFields.each do |field|
          subject.send(field).should == story.send(field).to_i
        end
      end

      it "date fields work" do
        TrackerIntegration::Story::DateFields.each do |field|
          subject.send(field).should == story.send(field)
        end
      end
    end
  end

  describe "refreshed_at" do
    it "invalidates updates once set" do
      feature = Factory :feature, refreshed_at: 1.day.ago
      feature.name = "Junk"
      feature.should_not be_valid
    end

    it "is valid if not set" do
      feature = Factory :feature, refreshed_at: nil
      feature.name = "Junk"
      feature.should be_valid
    end
  end

  describe "cost" do
    it "prices bugs at BugCost" do
      bug = Factory.build :feature, story_type: "bug", estimate: 100
      bug.cost.should == Feature::BugCost
    end
    it "prices chores at ChoreCost" do
      chore = Factory.build :feature, story_type: "chore", estimate: 100
      chore.cost.should == Feature::ChoreCost
    end
    it "prices feature at estimate" do
      feature = Factory.build :feature, estimate: 100
      feature.cost.should == 100
    end
    it "prices feature at 0 if estimate is negative" do
      feature = Factory.build :feature, estimate: -1
      feature.cost.should == 0
    end
  end

end
require 'spec_helper'

describe Feature do
  describe "validation" do
    it 'requires name' do
      Factory.build(:feature, name: nil).should_not be_valid
    end
  end

  describe "accepted_in_period" do
    let (:jan_feature) { Factory :feature, accepted_at: Time.new(2012,01,25) }
    let (:feb_feature) { Factory :feature, accepted_at: Time.new(2012,02,01) }

    it "finds on trailing boundary" do
      period_begin = Time.new(2012, 1, 1, 0, 0)
      period_end = Time.new(2012, 1, 31, 23, 59, 59)
      
      found = Feature.accepted_in_period(period_begin, period_end)
      found.should include jan_feature
      found.should_not include feb_feature
    end
 end

  describe "accepted_in_month" do 
    let (:jan_feature_first) {Factory :feature, accepted_at: Time.new(2012,1,1) }
    let (:jan_feature_last ) {Factory :feature, accepted_at: Time.new(2012,1,31) }
    let (:feb_feature_first) {Factory :feature, accepted_at: Time.new(2012,2,1) }
    let (:feb_feature_last) {Factory :feature, accepted_at: Time.new(2012,2,29) }

    it "excludes next months features" do
      features= Feature.accepted_in_month(Time.new(2012,01,05))

      features.should include jan_feature_first
      features.should include jan_feature_last
      
      features.should_not include feb_feature_first
      features.should_not include feb_feature_last
    end

    it "excludes previous months features" do
      features= Feature.accepted_in_month(Time.new(2012,02,05))

      features.should include feb_feature_first
      features.should include feb_feature_last

      features.should_not include jan_feature_first
      features.should_not include jan_feature_last      
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
      let(:feature) {Factory :feature}

      it "is valid" do
        subject.should be_valid
      end

      it "is getting refresh_time" do
        refresh_time = Time.new(2009,02,02)

        feature.update(story, refresh_time)

        feature.refreshed_at.should == refresh_time
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

require 'spec_helper'

describe Feature do
  describe "validation" do
    it 'requires name' do
      Factory.build(:feature, name: nil).should_not be_valid
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
      let(:story) { Factory.build :tracker_story }
      let(:subject) { (Factory :feature).update(story)}

      it "is valid" do
        subject.should be_valid
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

end
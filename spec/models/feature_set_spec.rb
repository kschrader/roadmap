require 'spec_helper'

describe FeatureSet do
  let (:accepted1) {
    Factory :feature, current_state: 'accepted', estimate: 1
  }
  let (:accepted2) {
    Factory :feature, current_state: 'accepted', estimate: 2
  }
  let (:other) {
    Factory :feature, current_state: 'open', estimate: 99
  }
  let (:bug) {
    Factory :bug
  }
  let (:unestimated) {
    Factory :feature, current_state: 'unscheduled', estimate: -1
  }
  let (:subject) {
    FeatureSet.new([accepted1, accepted2, other, unestimated, bug])
  }

  describe "total_estimate" do
    it "works" do
      subject.total_estimate.should == 102
    end
  end

  describe "total_cost" do
    it "works" do
      subject.total_cost.should == 102.25
    end
  end

  describe "average_estimated_size" do
    it "handles 0 counts" do
      all_unestimated = [ unestimated, unestimated]
      set = FeatureSet.new(all_unestimated)
      set.average_estimated_size.should == 0
    end
  end


  describe "total_in_state" do
    it "works" do
      subject.total_in_state(:accepted).should == 3
    end
    it "handles nil" do
      subject.total_in_state(nil).should == 0
    end
  end

  describe "unestimated_count" do
    it "works" do
      subject.unestimated_count.should == 1
    end
  end

  describe "unestimated_points" do
    it "is projected from estimated features" do
      subject.unestimated_points.should ==
        (subject.average_estimated_size * subject.unestimated_count)
    end
  end

end
require 'spec_helper'

describe "Bundle" do
  let(:bundle) {Factory :bundle }
  let(:create_features) {
          3.times do
        Factory :feature, estimate: 5, bundle_ids: [bundle.id]
      end
  }

  describe"estimates_total" do

    it "adds up total correctly" do
      create_features
      
      bundle.estimates_total.should == 15
    end

    it "does not add negative numbers" do
      create_features
      factory =Factory :feature, estimate: -2, bundle_ids: [bundle.id]

      bundle.estimates_total.should == 15
    end
  end

  describe "unestimated_total" do
    let (:create_nill_features) {
      2.times do
        Factory :feature, estimate: nil, bundle_ids: [bundle.id]
      end
    }

    it "adds up total correctly" do
      create_nill_features

      bundle.unestimated_total.should == 2
    end

    it "only adds nills up" do
      create_features
      create_nill_features

      bundle.unestimated_total.should == 2
    end
  end
end
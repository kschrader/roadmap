require 'spec_helper'

describe Bundle do

  it "total_estimates" do
    bundle = Factory :bundle 
    factory =Factory :feature, estimate: 5, bundle_ids: [bundle.id]
    factory =Factory :feature, estimate: -2, bundle_ids: [bundle.id]
    factory =Factory :feature, estimate: 3, bundle_ids: [bundle.id]
    bundle_total_estimates = bundle.total_estimates
    
    bundle_total_estimates.should == 8
  end

  it "unestimated_total " do
    bundle = Factory :bundle 
    factory =Factory :feature, estimate: 5, bundle_ids: [bundle.id]
    factory =Factory :feature, estimate: -2, bundle_ids: [bundle.id]
    factory =Factory :feature, estimate: 3, bundle_ids: [bundle.id]
    factory =Factory :feature, estimate: nil, bundle_ids: [bundle.id]
    factory =Factory :feature, estimate: nil, bundle_ids: [bundle.id]
    unestimated_total_number = bundle.unestimated_total

    unestimated_total_number.should == 2
  end

end
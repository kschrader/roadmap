require 'spec_helper'

describe FeaturesController do
  include BilgePump::Specs

  def attributes_for_create
    { name: "Created Feature" }
  end

  def attributes_for_update
    { name: "Updated Feature" }
  end

  describe "PUT refresh" do
    let (:stories) {
      2.times do 
        Factory.build :tracker_story
      end
    }
    
    it "works" do
      TrackerIntegration.should_receive(:update_stories)
      put :refresh
      response.should be_redirect
    end
  end

end

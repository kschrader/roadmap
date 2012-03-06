require 'spec_helper'

describe RefreshController do

  render_views

  describe "GET refresh" do
    it "responds 200 OK" do
      get :refresh
      response.should be_success
    end
  end

  describe "PUT run_refresh" do
    let (:stories) {
      2.times do 
        Factory.build :tracker_story
      end
    }
    
    it "responds w redirect" do
      TrackerIntegration.should_receive(:update_project)
      put :run_refresh,
        tracker_project_id: "pants",
        api_token: "pants"


      response.should be_redirect
    end

    it "requires project_id param" do
      TrackerIntegration.should_not_receive(:update_project)

      lambda do 
        put :run_refresh,
          api_token: "foo"
      end.should raise_error ArgumentError
    end

  end
end
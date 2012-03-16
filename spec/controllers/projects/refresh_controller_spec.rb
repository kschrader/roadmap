require 'spec_helper'

describe Projects::RefreshController do
  let (:project) { Factory :project }

  render_views

  describe "GET refresh" do
    it "responds 200 OK" do
      get :refresh, project_id: project.id
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
        project_id: project.id,
        api_token: "pants"
      response.should be_redirect
    end

  end
end
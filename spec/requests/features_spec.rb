require 'spec_helper'

describe "Features" do
  describe "GET /features" do
    it "works! (now write some real specs)" do
      project = Factory :project
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get project_features_path(project)
      response.status.should be(200)
    end
  end
end

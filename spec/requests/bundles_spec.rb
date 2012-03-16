require 'spec_helper'

describe "Bundles" do
  describe "GET /bundles" do
    it "works! (now write some real specs)" do
      project = Factory :project
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get project_bundles_path(project)
      response.status.should be(200)
    end
  end
end

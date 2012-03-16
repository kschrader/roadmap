require "spec_helper"

describe BundlesController do
  describe "routing" do
    let(:project) {Factory :project, name: "project101"}


    it "routes to #index" do
      get("/projects/#{project.name}/bundles").should route_to("bundles#index",:project_id => project.name)
    end

    it "routes to #new" do
      get("/projects/#{project.name}/bundles/new").should route_to("bundles#new",:project_id => project.name)
    end

    it "routes to #show" do
      get("/projects/#{project.name}/bundles/1").should route_to("bundles#show", :project_id => project.name, :id => "1")
    end

    it "routes to #edit" do
      get("/projects/#{project.name}/bundles/1/edit").should route_to("bundles#edit", :project_id => project.name, :id => "1")
    end

    it "routes to #create" do
      post("/projects/#{project.name}/bundles").should route_to("bundles#create", :project_id => project.name)
    end

    it "routes to #update" do
      put("/projects/#{project.name}/bundles/1").should route_to("bundles#update", :project_id => project.name, :id => "1")
    end

    it "routes to #destroy" do
      delete("/projects/#{project.name}/bundles/1").should route_to("bundles#destroy", :project_id => project.name, :id => "1")
    end

  end
end

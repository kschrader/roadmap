require "spec_helper"

describe FeaturesController do
  describe "routing" do
    let(:project) {Factory :project, name: "project101"}

    it "routes to #index" do
     
      get("/projects/#{project.name}/features").should route_to("features#index", :project_id => project.name)
    end

    it "routes to #new" do
      get("/projects/#{project.name}/features/new").should route_to("features#new",:project_id => project.name)
    end

    it "routes to #show" do
      get("projects/#{project.name}/features/1").should route_to("features#show", :project_id => project.name, :id => "1")
    end

    it "routes to #edit" do
      get("/projects/#{project.name}/features/1/edit").should route_to("features#edit", :project_id => project.name, :id => "1")
    end

    it "routes to #create" do
      post("/projects/#{project.name}/features").should route_to("features#create",:project_id => project.name)
    end

    it "routes to #update" do
      put("/projects/#{project.name}/features/1").should route_to("features#update",:project_id => project.name, :id => "1")
    end

    it "routes to #destroy" do
      delete("/projects/#{project.name}/features/1").should route_to("features#destroy", :project_id => project.name, :id => "1")
    end

  end
end

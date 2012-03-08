require 'spec_helper'
describe ProjectsController do
 
   let (:project) { Factory :project }

   describe "show" do
    let (:bundle) { Factory :bundle }

    it "finds a project by :id" do
      get :show, :id => project.id
      showed_project = assigns(:project)
      showed_project.should == project
    end

    it "returns associated bundles on project" do
      get :show, :id => bundle.project.id
      showed_project = assigns(:project)
      showed_project.bundles.all.should include bundle
    end
  end

  describe "edit" do
    it "works" do
      get :edit, 
        id: project.id

      response.should be_success
      assigns(:project).should == project
    end
  end

  describe "update" do
    it "works" do
      put :update,
        id: project.id,
        project: {
          name: "OMG I LOVE UPDATE"
        }

      assigns(:project).name.should == "OMG I LOVE UPDATE"
      response.should be_redirect
    end
  end

  describe "new" do
    it "works" do
      get :new

      assigns(:project).should_not be_nil
      assigns(:project).class.should == Project
      response.should be_success
    end
  end

  describe "create" do
    it "works" do
      # POST "/projects"
      post 'create' , :project => {"name" => "NRD" }

      created_project = Project.find_by_name("NRD")
      created_project.should_not be_nil
    end
  end

  describe "index" do
    it "works" do
      get :index
      assigns(:projects).should include project
      response.should be_success
    end
  end

  describe "delete" do
    it "works" do
    delete :destroy,
        id: project.id

      response.should be_redirect
      created_project = Project.find_by_name("NRD")
      created_project.should be_nil
    end
  end

end


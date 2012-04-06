 require 'spec_helper'

describe BundlesController do
  include BilgePump::Specs
  
  model_scope [:project]
  model_class Bundle

  def attributes_for_create 
    { name: "Create Name"}
  end

  def attributes_for_update 
    { name: "Update Name"}
  end


  describe "show" do
    let(:project) {Factory :project, name: "project101"}
    let(:bundle)  {Factory :bundle, project_id: project.id}
    let (:create_feature_with_hello_bundle_id) {
          Factory :feature, bundle_ids: ["hello"], name: "not_attached",:project_id => project.id}
    let(:create_feature_with_same_bundle_id) {
          Factory :feature, bundle_ids: [bundle.id], name: "attached", :project_id => project.id}

    it "shows features NOT attached to the bundle" do
      project
      bundle
      create_feature_with_same_bundle_id
      create_feature_with_hello_bundle_id

      get :show, :project_id => project.id, :id => bundle.id

      assigns(:available_features).should_not == []
      assigns(:available_features)[0].name.should == create_feature_with_hello_bundle_id.name
      
    end

    it "shows features that are attached to the bundle" do

      bundle
      create_feature_with_same_bundle_id
      create_feature_with_hello_bundle_id

      get :show, :project_id => project.id, :id => bundle.id

      assigns(:available_features).should_not == []
      assigns(:attached_features)[0].name.should == create_feature_with_same_bundle_id.name
    end
  end
end
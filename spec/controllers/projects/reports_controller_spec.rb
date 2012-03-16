require 'spec_helper'

describe Projects::ReportsController do
  let (:project) { Factory :project }

  describe "billing" do
    let (:jan_feature) { Factory :feature, project_id: project.id, accepted_at: DateTime.new(2012,01,15) }
    let (:feb_feature) { Factory :feature, project_id: project.id, accepted_at: DateTime.new(2012,02,15) }

    let (:project_with_features) {
      jan_feature
      feb_feature
      project
    }

    it "renders 200 OK" do
      get :billing, project_id: project.id
      response.should be_success
    end

    it "assigns at least one set by default" do
      Time.stub(:now).and_return(DateTime.new(2012,1,31).to_time)
      get :billing, project_id: project_with_features.id
      accepted = assigns(:accepted_features_by_month)
      accepted.should_not be_empty
      jan_2012 = DateTime.new(2012,1)
      accepted[jan_2012].should include jan_feature
    end

    it "accepts date range" do
      get :billing,
        project_id: project_with_features.id,
        period_begin: Time.new(2012, 1, 1),
        period_end: Time.new(2012, 1, 31)

        jan_2012 = DateTime.new(2012,1)
        feb_2012 = DateTime.new(2012,2)

        accepted = assigns(:accepted_features_by_month)
        accepted.keys.should include jan_2012
        accepted.keys.should_not include feb_2012
    end

  end
end
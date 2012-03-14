require 'spec_helper'

describe Project do

  describe "featureset_for_month" do
    let (:project) { Factory :project }

    let (:jan_feature) { Factory :feature, project_id: project.id, accepted_at: DateTime.new(2012,01,15) }
    let (:feb_feature) { Factory :feature, project_id: project.id, accepted_at: DateTime.new(2012,02,15) }

    let (:project_with_features) {
      jan_feature
      feb_feature
      project
    }

    it "includes features accepted in month" do
      featureset = project_with_features.featureset_for_month(DateTime.new(2012,01))
      featureset.should include jan_feature
      featureset.should_not include feb_feature
    end
  end
end
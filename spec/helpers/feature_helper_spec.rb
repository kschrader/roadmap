require 'spec_helper'

describe FeatureHelper do
  describe 'format_float' do
    it "is set to precision of 1" do
      helper.format_float(1.999999).should eq '2.0'
    end
  end
end
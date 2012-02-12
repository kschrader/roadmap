require 'spec_helper'

describe Feature do
  describe "validation" do
    it 'requires name' do
      Factory.build(:feature, name: nil).should_not be_valid
    end
  end
end
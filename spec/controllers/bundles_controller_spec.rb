require 'spec_helper'

describe BundlesController do
  include BilgePump::Specs

  def attributes_for_create 
    { name: "Create Name"}
  end

  def attributes_for_update 
    { name: "Update Name"}
  end
end

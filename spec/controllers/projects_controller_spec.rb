require 'spec_helper'
describe ProjectsController do
  include BilgePump::Specs

  def attributes_for_create
    { name: "Create NAME"}
  end

  def attributes_for_update
    { name: "Update NAME" }
  end

end


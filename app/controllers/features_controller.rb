class FeaturesController < ApplicationController
  include BilgePump::Controller

  def tagged
    @features = Feature.with_label(params[:value]).all
    render 'index'
  end
end

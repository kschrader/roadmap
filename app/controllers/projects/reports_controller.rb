module Projects
  class ReportsController < ApplicationController

    before_filter :project

    def billing
      period_end = Time.now
      period_start = period_end - 11.months

      month_begin = DateTime.new(period_start.year, period_start.month, 1).to_time
      month_end = DateTime.new(period_end.year, period_end.month, 31).to_time

      all_features = @project.features.accepted_in_period(month_begin, month_end).all

      features_by_month = Hash.new { |hash, key| hash[key] = Array.new }

      all_features.each do |f|
        features_by_month[f.accepted_at.strftime("%b %Y")] << f
      end

      @accepted_features_by_month = Hash.new

      features_by_month.keys.each do |key|
        @accepted_features_by_month[key] = FeatureSet.new(features_by_month[key])
      end

      @accepted_features_by_month
    end

    protected

    def project
      @project = Project.find(params[:project_id])
    end

  end
end
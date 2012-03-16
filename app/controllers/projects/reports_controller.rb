module Projects
  class ReportsController < ApplicationController

    before_filter :project
    before_filter :set_period

    def billing
      features_by_month = Hash.new { |hash, key| hash[key] = Array.new }

      accepted_features.each do |f|
        month = DateTime.new(f.accepted_at.year, f.accepted_at.month)
        features_by_month[month] << f
      end

      @accepted_features_by_month = Hash.new

      features_by_month.keys.each do |key|
        @accepted_features_by_month[key] =
          FeatureSet.new(
            features_by_month[key],
            key.strftime("%b %Y"),
            key
          )
      end

      @accepted_features_by_month
    end

    def billing_detail
      @featureset = FeatureSet.new(accepted_features)
    end

    protected

    def set_period
      now = Time.now
      @period_end =
        begin
          Date.parse(params[:period_end]).to_time
        rescue
          Time.new(now.year, now.month, 31)
        end

      before = (@period_end - 11.months)
      @period_start =
        begin
          Date.parse(params[:period_begin]).to_time
        rescue
          Time.new(before.year, before.month, 1)
        end
    end

    def accepted_features
      @project.features.accepted_in_period(@period_start, @period_end).all
    end

    def project
      @project = Project.find(params[:project_id])
    end

  end
end
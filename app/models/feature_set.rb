class FeatureSet < Struct.new(:features, :label, :sort_field)

  def include?(feature)
    features.include? feature
  end

  def count
    features.count
  end

  def total_estimate
    @total_estimate ||= sum_estimates(features)
  end

  def total_cost
    @total_cost ||= features.inject(0) { |sum, f| sum + f.cost }
  end

  def average_estimated_size
    @average_estimated_size ||=
      if ((count = features.count - unestimated_count) > 0)
        ( total_estimate.to_f /
          (count - unestimated_count).to_f )
        else
          0
      end
  end

  def features_by_accepted_date
    features.sort do |x,y|
      x.accepted_at <=> y.accepted_at
    end
  end

  def total_in_state(state)
    if (state.present?)
      sum_estimates(in_state(state))
    else
      0
    end
  end

  def count_in_state(state)
    if (state.present?)
      in_state(state).count
    else
      0
    end
  end

  def unestimated_count
    unestimated_count ||= features.select do |f|
      f.estimate.to_i < 0
    end.count
  end

  def unestimated_points
    average_estimated_size * unestimated_count
  end

  def <=> (other)
    sort_field <=> other.sort_field
  end

  def bug_types
    by_type(TrackerIntegration::StoryType::Bug)
  end

  def chore_types
    by_type(TrackerIntegration::StoryType::Chore)
  end

  def feature_types
    by_type(TrackerIntegration::StoryType::Feature)
  end

  protected

  def by_type(story_type)
    features.select { |f| f.story_type == story_type }
  end

  def in_state(state)
    features.select do |f|
      f.current_state.try(:to_sym) == state.to_sym
    end
  end

  def sum_estimates(features_to_sum)
    features_to_sum.map(&:estimate).inject(0) do |sum, e|
      value = e.to_i || 0
      value = 0 if value < 0
      sum += value
    end
  end

end

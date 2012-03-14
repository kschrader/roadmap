class FeatureSet < Struct.new(:features)

  def include?(feature)
    features.include? feature
  end

  def total_estimate
    @total_estimate ||= sum_estimates(features)
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

  protected

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

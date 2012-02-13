module FeatureHelper
  def format_float(number)
    number_with_precision(number, precision:1)
  end
end
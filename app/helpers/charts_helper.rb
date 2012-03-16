module ChartsHelper

  def chart_options(options = {})
    {
      'data-chart-type' => 'ColumnChart',
      'data-chart-height' => 425,
      'data-chart-width' => 700,
      'data-chart-legend' => 'right',
      'data-chart-chart_area.width' => 550,
      'data-chart-chart_area.height' => 325,
    }.merge(options)
  end
end
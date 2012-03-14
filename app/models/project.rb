class Project
  include MongoMapper::Document

  friendly_id :name

  key :name,                String, required: true
  key :tracker_project_id,  Integer

  has_many :bundles
  has_many :features

  def featureset_for_month(datetime)
    period_begin = DateTime.new(datetime.year, datetime.month, 1).to_time
    period_end = DateTime.new(datetime.year, datetime.month, 31).to_time

    FeatureSet.new(
      features
        .where(:accepted_at.gte => period_begin)
        .where(:accepted_at.lte => period_end)
        .all
    )
  end

end
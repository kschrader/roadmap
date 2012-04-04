class Project
  include MongoMapper::Document

   friendly_id :name

  key :name,                String, required: true
  key :tracker_project_id,  Integer
  key :refreshed_at,        Time

  has_many :bundles
  has_many :features

end
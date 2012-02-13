class Bundle
  include MongoMapper::Document

  friendly_id :name

  key :name,          String, required: true

end
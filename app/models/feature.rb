class Feature
  include MongoMapper::Document

  key :name,        String, required: true
  key :description, String
  key :size,        Integer

end
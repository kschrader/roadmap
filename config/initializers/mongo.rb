mongo_config = YAML::load(File.read(Rails.root.join("config/database.yml")))
MongoMapper.config = mongo_config
MongoMapper.connect Rails.env
MongoMapper.database = "roadmap-#{Rails.env}"
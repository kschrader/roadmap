RSpec.configure do |config|
  config.after(:each) do
    MongoMapper.database.collections.each do |c|
      c.drop unless c.name =~ /^system\./
    end
  end
end

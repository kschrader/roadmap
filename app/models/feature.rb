class Feature
  include MongoMapper::Document

  key :name,        String, required: true
  key :description, String
  key :estimate,    Integer
  key :labels,      Array

  scope :with_label, -> label do
    where :labels => label
  end

  def update_from_story(story)

    fillFromFieldList(
      story, 
      TrackerIntegration::Story::StringFields) do |value|
        value
      end

    fillFromFieldList(
      story, 
      TrackerIntegration::Story::ArrayFields) do |value|
        value.split ','
      end
    
    self
  end

  protected

  def fillFromFieldList(story, fieldlist)
    fieldlist.each do |field|
      value = story.send field
      if (value)
        self.send "#{field}=", yield(value)
      end
    end
  end

end
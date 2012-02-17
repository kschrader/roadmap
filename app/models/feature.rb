class Feature
  include MongoMapper::Document

  #TODO Milestone/Bundles/Piles
  #TODO Priority
  
  key :tracker_id,    Integer
  key :name,          String, required: true
  key :description,   String
  key :estimate,      Integer
  key :labels,        Array
  key :current_state, String
  key :project_id,    Integer
  
  key :refreshed_at,  Date

  key :bundle_ids,     Array
  many :bundles, :in => :bundle_ids

  scope :with_label, -> label do
    where :labels => label
  end

  validate :unchanged_after_refreshed

  def unchanged_after_refreshed
    if (changed? && refreshed_at_was.present? && !refreshed_at_changed?)
      errors.add(:base, "Can't update feature attributes after Tracker refresh") 
    end
  end

  def update(story)
    case story.class.to_s
    when 'PivotalTracker::Story'
      fill_from_field_list(
        story, 
        TrackerIntegration::Story::StringFields) do |value|
          value
        end

      fill_from_field_list(
        story, 
        TrackerIntegration::Story::ArrayFields) do |value|
          value.split ','
        end

      fill_from_field_list(
        story, 
        TrackerIntegration::Story::NumericFields) do |value|
          value.to_i
        end
      
      self.refreshed_at = Time.now
      self.tracker_id = story.id
    else
      super(story)
    end
    self
  end

  protected

  def fill_from_field_list(story, fieldlist)
    fieldlist.each do |field|
      value = story.send field
      if (value)
        self.send "#{field}=", yield(value)
      end
    end
  end

end
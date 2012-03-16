class Feature
  include MongoMapper::Document

  BugCost = 0.25
  ChoreCost = 0.25

  key :accepted_at,           Time
  key :current_state,         String
  key :description,           String
  key :estimate,              Integer
  key :labels,                Array
  key :name,                  String, required: true
  key :owned_by,              String
  key :refreshed_at,          Date
  key :story_id,              Integer
  key :story_type,            String
  key :tracker_project_id,    Integer

  key :project_id,            ObjectId
  belongs_to :project

  key :bundle_ids,            Array
  many :bundles, :in => :bundle_ids

  scope :with_label, -> label do
    where :labels => label
  end

  scope :accepted_in_period, -> period_start, period_end do
    where(:accepted_at.gte => period_start)
      .where(:accepted_at.lte => period_end)
  end

  scope :accepted_in_month, -> datetime do
    period_begin = DateTime.new(datetime.year, datetime.month, 1).to_time
    period_end = DateTime.new(datetime.year, datetime.month, 31).to_time
    accepted_in_period(period_begin, period_end)
  end

  validate :unchanged_after_refreshed

  def unchanged_after_refreshed
    if (changed? && refreshed_at_was.present? && !refreshed_at_changed?)
      errors.add(:base, "Can't update feature attributes after Tracker refresh")
    end
  end

  def cost
    case story_type
      when TrackerIntegration::StoryType::Bug then BugCost
      when TrackerIntegration::StoryType::Chore then ChoreCost
      else ( (estimate && (estimate > 0)) ? estimate : 0 )
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

      fill_from_field_list(
        story,
        TrackerIntegration::Story::DateFields) do |value|
          value
        end

      self.refreshed_at = Time.now
      self.tracker_project_id = story.project_id
      self.story_id = story.id
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
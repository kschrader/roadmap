module MongoMapperBilgePump
  extend ActiveSupport::Concern

  included do
    scope :scoped # anonymous scope alternative to all
  end
end

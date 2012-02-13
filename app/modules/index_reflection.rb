module IndexReflection
  extend ActiveSupport::Concern

  module ClassMethods
    def ensured_indexes
      @ensured_indexes ||= []
    end

    def ensure_index(*args)
      ensured_indexes << args
      super
    end

    def recreate_ensured_indexes!
      if superclass.respond_to?(:recreate_ensured_indexes!)
        superclass.recreate_ensured_indexes!
      end

      ensured_indexes.each do |args|
        collection.create_index *args
      end
    end
  end
end


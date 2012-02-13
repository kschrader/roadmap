module FriendlyId
  extend ActiveSupport::Concern

  module ClassMethods
    def friendly_id_field
      @friendly_id_field ||
      (superclass.friendly_id_field if superclass.respond_to?(:friendly_id_field))
    end

    def friendly_id(field)
      extend Methods::Class
      include Methods::Instance

      key :friendly_ids, Array

      ensure_index :friendly_ids

      scope :by_friendly_id, -> friendly_id do
        where friendly_ids: friendly_id
      end

      before_save :save_friendly_id

      @friendly_id_field = field
    end
  end

  module Methods
    module Class
      def try_friendly_id_find(*args)
        if args.size == 1 && String === args.first
          by_friendly_id(args.first).first
        end
      end

      def find(*args)
        try_friendly_id_find(*args) || super
      end

      def find!(*args)
        try_friendly_id_find(*args) || super
      end

      LETTERS = ('a'..'z').to_a
      NUMBERS = ('0'..'9').to_a

      def friendly_id_random_part
        [
          LETTERS[rand(LETTERS.size)],
          NUMBERS[rand(NUMBERS.size)],
          LETTERS[rand(LETTERS.size)],
          NUMBERS[rand(NUMBERS.size)]
        ].join
      end
    end

    module Instance
      def save_friendly_id
        if send("#{self.class.friendly_id_field}_changed?") ||
           (friendly_ids.empty? && friendly_id_base_value.present?)

          value = generate_friendly_id_value

          if value.present? && !friendly_ids.include?(value)
            friendly_ids.unshift value
          end
        end
      end

      def friendly_id_base_value
        send(self.class.friendly_id_field).parameterize
      end

      def generate_friendly_id_value
        base_value = friendly_id_base_value
        return '' if base_value.blank?

        actual_value = base_value

        while duplicate_friendly_id_exists? actual_value
          actual_value = base_value + "-" + self.class.friendly_id_random_part
        end

        actual_value
      end

      def duplicate_friendly_id_exists?(friendly_id)
        self.class.by_friendly_id(friendly_id)
                  .where(id: { :$ne => id }).exists?
      end

      def to_param
        return '' if new_record?
        friendly_ids.first.presence || super
      end
    end
  end

  module ManyDocumentsProxyExtensions
    def try_friendly_id_find(*args)
      if klass.respond_to?(:by_friendly_id) &&
         args.size == 1 && String === args.first
        by_friendly_id(args.first).first
      end
    end

    def find(*args)
      try_friendly_id_find(*args) || super
    end

    def find!(*args)
      try_friendly_id_find(*args) || super
    end
  end

  ::MongoMapper::Plugins::Associations::ManyDocumentsProxy.class_eval do
    include ManyDocumentsProxyExtensions
  end

  module InArrayProxyExtensions
    def self.included(mod)
      mod.class_eval do
        alias_method_chain :find, :friendly_id
        alias_method_chain :find!, :friendly_id
      end
    end

    def try_friendly_id_find(*args)
      if klass.respond_to?(:by_friendly_id) &&
         args.size == 1 && String === args.first
        query.by_friendly_id(args.first).first
      end
    end

    def find_with_friendly_id(*args)
      try_friendly_id_find(*args) ||
      find_without_friendly_id(*args)
    end

    def find_with_friendly_id!(*args)
      try_friendly_id_find(*args) ||
      find_without_friendly_id!(*args)
    end
  end

  ::MongoMapper::Plugins::Associations::InArrayProxy.class_eval do
    include InArrayProxyExtensions
  end
end

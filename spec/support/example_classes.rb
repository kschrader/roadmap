module ExampleClasses
  @count = 0

  def self.example_class(example, superclass = nil, &block)
    @count += 1
    const_set("C#{@count}", Class.new(superclass || Object)).tap do |c|
      c.singleton_class.class_eval do
        define_method(:example) { example }
      end
      c.class_eval &block if block
    end
  end

  module ExampleMethods
    def example_classes
      @example_classes ||= []
    end

    def example_class(superclass_or_symbol = nil, &block)
      if superclass_or_symbol.is_a?(Class)
        superclass = superclass_or_symbol

      elsif superclass_or_symbol
        superclass = send superclass_or_symbol

      else
        superclass = nil
      end

      ExampleClasses.example_class(self, superclass, &block).tap do |klass|
        example_classes << klass
      end
    end

    def example_document(superclass = nil, &block)
      example_class(superclass) do
        include MongoMapper::Document
        class_eval &block if block
      end
    end

    def example_embedded_document(superclass = nil, &block)
      example_class(superclass) do
        include MongoMapper::EmbeddedDocument
        class_eval &block if block
      end
    end
  end

  module ExampleGroupMethods
    ExampleMethods.instance_methods.each do |method|
      class_eval <<-end_src, __FILE__, __LINE__
        def #{method}(klass_name, superclass = nil, &block)
          define_method klass_name do
            ivar = "@_\#{klass_name}"
            val = instance_variable_get ivar
            val || instance_variable_set(ivar, #{method}(superclass, &block))
          end
        end
      end_src
    end
  end
end

RSpec.configure do |config|
  config.include ExampleClasses::ExampleMethods
  config.extend ExampleClasses::ExampleGroupMethods
end

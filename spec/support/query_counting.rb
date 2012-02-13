$spec_mongo_queries = []

RSpec.configure do |config|
  config.before :each do
    $spec_mongo_queries = []
  end
end

Mongo::Collection.class_eval do
  # find covers find_one
  # update / insert cover save
  %w(
  find
  insert
  remove
  update
  find_and_modify
  group
  ).each do |method|
    class_eval <<-src
      def #{method}_with_counting(*args)
        $spec_mongo_queries.push [name, :#{method}, *args]
        #{method}_without_counting *args
      end
      alias_method_chain :#{method}, :counting
    src
  end
end

RSpec::Matchers.define :run do |num|
  match do |block|
    $spec_mongo_queries = []
    block.call
    filter = @filter || -> _ { true }
    @matching = $spec_mongo_queries.select &filter
    num == @matching.size
  end

  chain :like do |filter|
    @filter = filter
  end

  failure_message_for_should do |block|
    <<-message
expected #{block} to run #{num} queries #{@filter ? 'matching ' + @filter.to_s : ''},
but ran #{@matching.size} instead.

Queries were:
    #{@matching.map(&:inspect).join("\n    ")}
    message
  end

  def queries
    self
  end

  def query
    self
  end
end


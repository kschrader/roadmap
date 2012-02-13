RSpec::Matchers.define :use_an_index do |options = {}|
  match do |actual|
    actual.model.recreate_ensured_indexes!

    @explain = actual.explain
    @cursor = @explain["cursor"]
    @cursor_matched = @cursor =~ /BtreeCursor/
    @only_matched = !options[:only] || @explain["indexOnly"]

    @cursor_matched && @only_matched
  end

  failure_message_for_should do |actual|
    messages = []

    if !@cursor_matched
      messages << <<-message
Expected query to use an index (BtreeCursor), but explain indicated it would use #{@cursor}
      message
    end

    if !@only_matched
      messages << <<-message
Expected query to use ONLY an index, but explain indicated it would have used a scan other than index.
      message
    end

    messages << <<-message
Full explain plan was:
#{PP.pp(@explain, "")}
    message

    messages.join("\n")
  end
end


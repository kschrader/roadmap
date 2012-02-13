require 'spec_helper'

describe FriendlyId do
  example_document :document do
    friendly_id :name
    key :name, String
    key :foo, String
  end

  describe "to_param" do
    it "is parameterized version of friendly id field" do
      d = document.create! name: 'Foo Bar'
      d.to_param.should == 'Foo Bar'.parameterize
    end

    it "is id if friendly id value parameterization is blank" do
      d = document.create! name: '-'
      d.to_param.should == d.id.to_s
    end

    it "is blank if new record" do
      d = document.new name: 'Foo Bar'
      d.to_param.should == ''
    end

    it "is old value if changed and unsaved" do
      d = document.create name: 'Foo Bar'
      d.name = 'Bar Foo'
      d.to_param.should == 'Foo Bar'.parameterize
    end

    it "is new value if changed and saved" do
      d = document.create name: 'Foo Bar'
      d.update_attributes name: 'Bar Foo'
      d.to_param.should == 'Bar Foo'.parameterize
    end
  end

  describe "friendly_ids" do
    it "is updated on save" do
      d = document.create! name: 'Foo Bar'
      d.update_attributes name: 'Bar Foo'
      d.friendly_ids.should include 'foo-bar', 'bar-foo'
    end

    it "doesn't add duplicates" do
      d = document.create! name: 'Foo Bar'
      d.update_attributes foo: 'baz'
      d.friendly_ids.should == ['foo-bar']
    end

    it "doesn't include blanks" do
      d = document.create! name: '-'
      d.friendly_ids.should == []
    end

    it "doesn't get added if validations fail" do
      document = example_document do
        friendly_id :name
        key :name, String
        key :foo, required: true
      end

      d = document.create! name: 'bar', foo: "baz"
      d.update_attributes(name: 'baz', foo: nil).should be_false
      d.friendly_ids.should == ['bar']
    end

    it "adds one if it doesn't exist on save, even if field hasn't changed" do
      d = document.create! name: 'foo'
      d.set friendly_ids: []
      d.reload
      d.update_attributes foo: 'baz'
      d.friendly_ids.should == ['foo']
    end
  end

  describe "uniqification" do
    it "generates uniq friendly ids" do
      d1 = document.create! name: "Foo"
      d2 = document.create! name: "Foo"

      document.find(d1.to_param).should == d1
      document.find(d2.to_param).should == d2
    end

    it "doesn't try to de-dup blank values" do
      document.create! name: "-"
      d2 = nil
      -> { d2 = document.create! name: "-" }.should run(1).query
      d2.to_param.should == d2.id.to_s
    end
  end

  describe "friendly_id_random_part" do
    it "has format letter-number-letter-number" do
      document.friendly_id_random_part.should =~ /\A([a-z][0-9]){2}\Z/
    end
  end

  describe "find" do
    it "finds by to_param" do
      d = document.create! name: 'Foo Bar'
      document.find(d.to_param).should == d
    end

    it "still finds by id" do
      d = document.create! name: 'Foo Bar'
      document.find(d.id).should == d
      document.find(d.id.to_s).should == d
      document.find([d.id]).should == [d]
    end
  end

  describe "find!" do
    it "finds by to_param" do
      d = document.create! name: 'Foo Bar'
      document.find!(d.to_param).should == d
    end

    it "still finds by id" do
      d = document.create! name: 'Foo Bar'
      document.find!(d.id).should == d
      document.find!(d.id.to_s).should == d
      document.find!([d.id]).should == [d]
    end

    it "raises error if doesn't exist" do
      -> do
        document.find! 'foo'
      end.should raise_error MongoMapper::DocumentNotFound
    end
  end

  describe "by_friendly_id" do
    it "uses an index" do
      d = document.create! name: 'Foo Bar'
      document.by_friendly_id(d.to_param).should use_an_index
    end
  end

  describe 'it works with subclasses' do
    example_document :superclass do
      friendly_id :name
      key :name
    end

    example_class :subclass, :superclass

    it 'works' do
      item = subclass.create! name: 'foo'
      subclass.find('foo').should == item
    end
  end

  describe 'it works through one-to-many associations' do
    example_document :parent do
      has_many :children, class_name: example.child.name,
        foreign_key: :parent_id
    end

    example_document :child do
      friendly_id :name

      key :name, String
      key :parent_id, ObjectId
    end

    it 'works' do
      p = parent.create!
      c = child.create! name: 'foo', parent_id: p.id
      p.children.find('foo').should == c
      p.children.find(c.id.to_s).should == c
      p.children.find(c.id).should == c
      p.children.find([c.id]).should == [c]
      p.children.find!('foo').should == c
      p.children.find!(c.id.to_s).should == c
      -> { p.children.find!('bar') }.should raise_error
    end

    it "doesn't find items that aren't children" do
      p = parent.create!
      child.create! name: 'foo', parent_id: parent.create!.id

      p.children.find('foo').should be_nil
    end
  end

  describe 'it works through many-to-many associations' do
    example_document :parent do
      key :child_ids, Array
      many :children, in: :child_ids, class_name: example.child.name
    end

    example_document :child do
      friendly_id :name

      key :name, String
    end

    it 'works' do
      c = child.create! name: 'foo'
      p = parent.create! child_ids: [c.id]

      p.children.find('foo').should == c
      p.children.find(c.id.to_s).should == c
      p.children.find(c.id).should == c

      # dv: this is the normal MM behavior, even though
      # it doesn't seem to match plucky's Query.find method
      p.children.find([c.id]).should == c

      p.children.find!('foo').should == c
      p.children.find!(c.id.to_s).should == c
      -> { p.children.find!('bar') }.should raise_error
    end

    it "doesn't find items that aren't children" do
      c = child.create! name: 'foo'
      p = parent.create! child_ids: []

      p.children.find('foo').should be_nil
    end
  end
end

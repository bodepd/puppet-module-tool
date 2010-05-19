require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ApplicationHelper do

  describe "count" do
    it "should show a count for a populated collection" do
      helper.count("thing", [1,2,3]).should have_tag('p', /3 things found/)
    end

    it "should show a disclaimer for an empty collection" do
      helper.count("thing", []).should have_tag("p", /No things found/)
    end
  end

  describe "tag_list" do
    it "should list tags" do
      name = "thing"
      taggable = mock(Mod, :tags => [Tag.new(:name => name)])
      helper.tag_list(taggable).should have_tag("a", name)
    end

    it "should list categories" do
      name = "os"
      category = Categories[name.to_sym]
      taggable = mock(Mod, :tags => [Tag.new(:name => "os")])
      helper.tag_list(taggable).should have_tag("a", category)
    end
  end

  describe "privilege_label" do
    it "should be '(DEV)' if in dev mode" do
      helper.stub!(:privileged? => :dev)
      helper.privilege_label.should == "(DEV)"
    end

    it "should be '(ADMIN') if in admin mode" do
      helper.stub!(:privileged? => :admin)
      helper.privilege_label.should == "(ADMIN)"
    end

    it "should be nil otherwise" do
      helper.stub!(:privileged? => false)
      helper.privilege_label.should be_nil
    end
  end

end
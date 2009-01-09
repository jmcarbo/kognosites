require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/pages/index.html.erb" do
  include PagesHelper
  
  before(:each) do
    assigns[:pages] = [
      stub_model(Page,
        :name => "value for name",
        :title => "value for title",
        :scope => "1",
        :contents => "value for contents"
      ),
      stub_model(Page,
        :name => "value for name",
        :title => "value for title",
        :scope => "1",
        :contents => "value for contents"
      )
    ]
  end

  it "should render list of pages" do
    render "/pages/index.html.erb"
    response.should have_tag("tr>td", "value for name", 2)
    response.should have_tag("tr>td", "value for title", 2)
    response.should have_tag("tr>td", "1", 2)
    response.should have_tag("tr>td", "value for contents", 2)
  end
end


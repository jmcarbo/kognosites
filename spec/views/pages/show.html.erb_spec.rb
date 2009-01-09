require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/pages/show.html.erb" do
  include PagesHelper
  
  before(:each) do
    assigns[:page] = @page = stub_model(Page,
      :name => "value for name",
      :title => "value for title",
      :scope => "1",
      :contents => "value for contents"
    )
  end

  it "should render attributes in <p>" do
    render "/pages/show.html.erb"
    response.should have_text(/value\ for\ name/)
    response.should have_text(/value\ for\ title/)
    response.should have_text(/1/)
    response.should have_text(/value\ for\ contents/)
  end
end


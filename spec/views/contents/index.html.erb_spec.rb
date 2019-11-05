require 'rails_helper'

RSpec.describe "contents/index", type: :view do
  before(:each) do
    assign(:contents, [
      Content.create!(
        :title => "Title",
        :body => "MyBody",
        :content_type => "MyContentType"
      ),
      Content.create!(
        :title => "Title",
        :body => "MyBody",
        :content_type => "MyContentType"
      )
    ])
  end

  it "renders a list of contents" do
    render
    assert_select "ul>li", :text => /Title/, :count => 2
  end
end

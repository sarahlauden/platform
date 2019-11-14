require 'rails_helper'

RSpec.describe "course_contents/index", type: :view do
  before(:each) do
    assign(:course_contents, [
      CourseContent.create!(
        :title => "Title",
        :body => "MyBody",
        :content_type => "MyCourseContentType"
      ),
      CourseContent.create!(
        :title => "Title",
        :body => "MyBody",
        :content_type => "MyCourseContentType"
      )
    ])
  end

  it "renders a list of course_contents" do
    render
    assert_select "ul>li", :text => /Title/, :count => 2
  end
end

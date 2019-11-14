require 'rails_helper'

RSpec.describe "course_contents/new", type: :view do
  before(:each) do
    assign(:course_content, CourseContent.new(
      :title => "MyString",
      :body => "MyText",
      :content_type => "MyText"
    ))
  end

  it "renders new course_content form" do
    render

    assert_select "form[action=?][method=?]", course_contents_path, "post"
  end
end

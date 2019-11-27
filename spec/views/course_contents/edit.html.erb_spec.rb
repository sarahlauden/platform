require 'rails_helper'

RSpec.describe "course_contents/edit", type: :view do
  before(:each) do
    @course_content = assign(:course_content, CourseContent.create!(
      :title => "MyString",
      :body => "MyText",
      :content_type => "MyText"
    ))
  end

  it "renders the edit course_content form" do
    render

    assert_select "form[action=?][method=?]", course_content_path(@course_content), "post"
  end
end

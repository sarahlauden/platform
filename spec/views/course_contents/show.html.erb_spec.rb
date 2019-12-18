require 'rails_helper'

RSpec.describe "course_contents/show", type: :view do
  before(:each) do
    @course_content = assign(:course_content, CourseContent.create!(
      :title => "Title",
      :body => "MyText",
      :content_type => "MyText"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Title/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/MyText/)
  end
end

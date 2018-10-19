require 'rails_helper'

RSpec.describe "industries/index", type: :view do
  before(:each) do
    assign(:industries, [
      Industry.create!(
        :name => "Name"
      ),
      Industry.create!(
        :name => "Name"
      )
    ])
  end

  it "renders a list of industries" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
  end
end

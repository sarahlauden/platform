require 'canvas_api'

class CourseContent < ApplicationRecord
  def publish(params)
    canvas = CanvasAPI.new(Rails.application.secrets.canvas_url,
        Rails.application.secrets.canvas_token)

    response = canvas.update_course_page(params[:course_id], params[:secondary_id], params[:body])

    response.code == 200
  end
end
